provider "azurerm" {
  features {}
}

data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

data "sysdig_secure_agentless_scanning_assets" "assets" {}

resource "azurerm_lighthouse_definition" "lighthouse_definition" {
  name               = "Sysdig Agentless Host Scanner"
  description        = "Lighthouse definition for Sysdig Agentless Host Scanner"
  managing_tenant_id = data.sysdig_secure_agentless_scanning_assets.assets.azure.tenant_id
  scope              = "/subscriptions/${var.subscription_id}"
  authorization {
    principal_id           = data.sysdig_secure_agentless_scanning_assets.assets.azure.service_principal_id
    principal_display_name = "Sysdig Service Principal Agentless Host Scanner"
    # Uses VM Scanner Operator role
    role_definition_id = "d24ecba3-c1f4-40fa-a7bb-4588a071e8fd"
  }
}

resource "azurerm_lighthouse_assignment" "lighthouse_assignment" {
  count                    = var.is_organizational ? 0 : 1
  scope                    = "/subscriptions/${var.subscription_id}"
  lighthouse_definition_id = azurerm_lighthouse_definition.lighthouse_definition.id
}

#-----------------------------------------------------------------------------------------------------------------
# Call Sysdig Backend to add the service-principal integration for Agentless Scanning to the Sysdig Cloud Account
#
# Note (optional): To ensure this gets called after all cloud resources are created, add
# explicit dependency using depends_on
#-----------------------------------------------------------------------------------------------------------------
resource "sysdig_secure_cloud_auth_account_component" "azure_service_principal" {
  account_id                 = var.sysdig_secure_account_id
  type                       = "COMPONENT_SERVICE_PRINCIPAL"
  instance                   = "secure-scanning"
  service_principal_metadata = jsonencode({
    azure = {
      active_directory_service_principal = {
        id = "Azure Lighthouse"
      }
    }
  })
}