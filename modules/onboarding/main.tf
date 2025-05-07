data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

data "sysdig_secure_trusted_azure_app" "onboarding" {
  name = "onboarding"
}

#---------------------------------------------------------------------------------------------------
# Create service principal in customer tenant, using the Sysdig Managed Application for Onboarding
#
# If there is an existing service principal in the tenant, this will automatically import
# and use it, ensuring we have just one service principal linked to the Sysdig application
# in the customer tenant.
# Note: Please refer to the caveats of use_existing attribute for this resource.
#
# Note: Once created, this cannot be deleted via Terraform. It can be manually deleted from Azure.
#       This is to safeguard against unintended deletes if the service principal is in use.
#----------------------------------------------------------------------------------------------------
data "azuread_service_principal" "sysdig_onboarding_sp" {
  count     = var.onboarding_service_principal != "" ? 1 : 0
  object_id = var.onboarding_service_principal
}

resource "azuread_service_principal" "sysdig_onboarding_sp" {
  count        = var.onboarding_service_principal != "" ? 0 : 1
  client_id    = data.sysdig_secure_trusted_azure_app.onboarding.application_id
  use_existing = true
  notes        = "Service Principal linked to the Sysdig Secure CNAPP - Onboarding module"
}

#-------------------------------------------------------------------------------------------------
# Assign "Reader" role to Sysdig Onboarding SP for primary subscription, for retrieving inventory
#-------------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_onboarding_reader" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
  principal_id         = var.onboarding_service_principal != "" ? data.azuread_service_principal.sysdig_onboarding_sp[0].object_id : azuread_service_principal.sysdig_onboarding_sp[0].object_id
}

#---------------------------------------------------------------------------------------------
# Call Sysdig Backend to create account with foundational onboarding
# (ensure it is called after all above cloud resources are created using explicit depends_on)
#---------------------------------------------------------------------------------------------
resource "sysdig_secure_cloud_auth_account" "azure_account" {
  enabled            = true
  provider_id        = var.subscription_id
  provider_type      = "PROVIDER_AZURE"
  provider_alias     = data.azurerm_subscription.primary.display_name
  provider_tenant_id = var.tenant_id

  component {
    type     = "COMPONENT_SERVICE_PRINCIPAL"
    instance = "secure-onboarding"
    version  = "v0.1.0"
    service_principal_metadata = jsonencode({
      azure = {
        active_directory_service_principal = {
          account_enabled           = true
          display_name              = var.onboarding_service_principal != "" ? data.azuread_service_principal.sysdig_onboarding_sp[0].display_name : azuread_service_principal.sysdig_onboarding_sp[0].display_name
          id                        = var.onboarding_service_principal != "" ? data.azuread_service_principal.sysdig_onboarding_sp[0].object_id : azuread_service_principal.sysdig_onboarding_sp[0].object_id
          app_display_name          = var.onboarding_service_principal != "" ? data.azuread_service_principal.sysdig_onboarding_sp[0].display_name : azuread_service_principal.sysdig_onboarding_sp[0].display_name
          app_id                    = var.onboarding_service_principal != "" ? data.azuread_service_principal.sysdig_onboarding_sp[0].client_id : azuread_service_principal.sysdig_onboarding_sp[0].client_id
          app_owner_organization_id = var.onboarding_service_principal != "" ? data.azuread_service_principal.sysdig_onboarding_sp[0].application_tenant_id : azuread_service_principal.sysdig_onboarding_sp[0].application_tenant_id
        }
      }
    })
  }

  depends_on = [azurerm_role_assignment.sysdig_onboarding_reader]

  lifecycle {
    ignore_changes = [
      component,
      feature
    ]
  }
}