#---------------------------------------------------------------------------------------------
# Fetch the subscription data
#---------------------------------------------------------------------------------------------
data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

locals {
  agentless_aks_connection_permissions_actions = ["Microsoft.ContainerService/managedClusters/listClusterAdminCredential/action"]
}

#---------------------------------------------------------------------------------------------
# Create a Custom role for collecting authsettings
#---------------------------------------------------------------------------------------------
resource "azurerm_role_definition" "sysdig_cspm_aks_discovery_role" {
  count = var.is_organizational ? 0 : 1

  name        = "sysdig-cspm-role-aks-discovery-${var.subscription_id}"
  scope       = data.azurerm_subscription.primary.id
  description = "Custom role for AKS Discovery"

  permissions {
    actions     = local.agentless_aks_connection_permissions_actions
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}

#---------------------------------------------------------------------------------------------
# Custom role assignment for AKS Discovery
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_cspm_role_aks_discovery_assignment" {
  count = var.is_organizational ? 0 : 1

  scope              = data.azurerm_subscription.primary.id
  role_definition_id = azurerm_role_definition.sysdig_cspm_aks_discovery_role[0].role_definition_resource_id
  principal_id       = var.sysdig_cspm_sp_object_id
}

#--------------------------------------------------------------------------------------------------------------
# Call Sysdig Backend to add a dummy service-principal which represents the existence of AKS integration
#
#--------------------------------------------------------------------------------------------------------------
resource "sysdig_secure_cloud_auth_account_component" "azure_service_principal" {
  account_id                 = var.sysdig_secure_account_id
  type                       = "COMPONENT_SERVICE_PRINCIPAL"
  instance                   = "secure-posture-aks"
  service_principal_metadata = jsonencode({
    azure = {
      active_directory_service_principal = {
        account_enabled           = true
        display_name              = var.sysdig_cspm_sp_display_name
        id                        = var.sysdig_cspm_sp_object_id
        app_display_name          = var.sysdig_cspm_sp_display_name
        app_id                    = var.sysdig_cspm_sp_client_id
        app_owner_organization_id = var.sysdig_cspm_sp_application_tenant_id
      }
      aks_discovery_permission_grant = true
    }
  })

  depends_on = [azurerm_role_definition.sysdig_cspm_role_aks_discovery_for_tenant,
    azurerm_role_assignment.sysdig_cspm_role_assignment_for_tenant,
    azurerm_role_definition.sysdig_cspm_aks_discovery_role,
    azurerm_role_assignment.sysdig_cspm_role_aks_discovery_assignment
  ]
}