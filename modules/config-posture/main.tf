#---------------------------------------------------------------------------------------------
# Fetch the subscription data
#---------------------------------------------------------------------------------------------
data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

data "sysdig_secure_trusted_azure_app" "config_posture" {
	name = "config_posture"
}

locals {
  sysdig_cspm_role_default_permissions_actions = ["Microsoft.Web/sites/config/list/action"]
  agentless_aks_connection_permissions_actions = var.agentless_aks_connection_enabled ? ["Microsoft.ContainerService/managedClusters/listClusterAdminCredential/action"] : []

  sysdig_cspm_role_permissions_actions = tolist(setunion(local.sysdig_cspm_role_default_permissions_actions, local.agentless_aks_connection_permissions_actions))
}

#--------------------------------------------------------------------------------------------------------------
# Create service principal in customer tenant, using the Sysdig Managed Application for Config Posture (CSPM)
#
# If there is an existing service principal in the tenant, this will automatically import
# and use it, ensuring we have just one service principal linked to the Sysdig application
# in the customer tenant.
# Note: Please refer to the caveats of use_existing attribute for this resource.
#
# Note: Once created, this cannot be deleted via Terraform. It can be manually deleted from Azure.
#       This is to safeguard against unintended deletes if the service principal is in use.
#--------------------------------------------------------------------------------------------------------------
resource "azuread_service_principal" "sysdig_cspm_sp" {
  client_id    = data.sysdig_secure_trusted_azure_app.config_posture.application_id
  use_existing = true
}

#---------------------------------------------------------------------------------------------
# Assign "Directory Reader" AD role to Sysdig SP
#---------------------------------------------------------------------------------------------
resource "azuread_directory_role_assignment" "sysdig_ad_reader" {
  role_id             = "88d8e3e3-8f55-4a1e-953a-9b9898b8876b" // template ID of Directory Reader AD role
  principal_object_id = azuread_service_principal.sysdig_cspm_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Reader" role to Sysdig SP for primary subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_reader" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sysdig_cspm_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Create a Custom role for collecting authsettings
#---------------------------------------------------------------------------------------------
resource "azurerm_role_definition" "sysdig_cspm_role" {
  name        = "sysdig-cspm-role-${var.subscription_id}"
  scope       = data.azurerm_subscription.primary.id
  description = "Custom role for collecting Authsettings for CIS Benchmark"

  permissions {
    actions     = local.sysdig_cspm_role_permissions_actions
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}

#---------------------------------------------------------------------------------------------
# Custom role assignment for collecting authsettings
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_cspm_role_assignment" {
  scope              = data.azurerm_subscription.primary.id
  role_definition_id = azurerm_role_definition.sysdig_cspm_role.role_definition_resource_id
  principal_id       = azuread_service_principal.sysdig_cspm_sp.object_id
}

#--------------------------------------------------------------------------------------------------------------
# Call Sysdig Backend to add the service-principal integration for Config Posture to the Sysdig Cloud Account
#
# Note (optional): To ensure this gets called after all cloud resources are created, add
# explicit dependency using depends_on
#--------------------------------------------------------------------------------------------------------------
resource "sysdig_secure_cloud_auth_account_component" "azure_service_principal" {
  account_id                 = var.sysdig_secure_account_id
  type                       = "COMPONENT_SERVICE_PRINCIPAL"
  instance                   = "secure-posture"
  service_principal_metadata = jsonencode({
    azure = {
      active_directory_service_principal = {
        account_enabled           = true
        display_name              = azuread_service_principal.sysdig_cspm_sp.display_name
        id                        = azuread_service_principal.sysdig_cspm_sp.id
        app_display_name          = azuread_service_principal.sysdig_cspm_sp.display_name
        app_id                    = azuread_service_principal.sysdig_cspm_sp.client_id
        app_owner_organization_id = azuread_service_principal.sysdig_cspm_sp.application_tenant_id
      }
    }
  })
}
