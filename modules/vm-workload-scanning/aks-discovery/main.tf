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
resource "random_string" "random1" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_role_definition" "sysdig_cspm_aks_discovery_role" {

  name        = "sysdig-cspm-role-aks-discovery-${var.subscription_id}-${random_string.random1.result}"
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
  count               = var.use_existing_role_assignments ? 0 : 1
  scope               = data.azurerm_subscription.primary.id
  role_definition_id  = azurerm_role_definition.sysdig_cspm_aks_discovery_role.role_definition_resource_id
  principal_id        = var.sysdig_cspm_sp_object_id
}
