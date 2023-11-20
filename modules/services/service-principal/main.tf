provider "azurerm" {
  features {}
}

data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

#---------------------------------------------------------------------------------------------
# Create service principal in customer tenant
# TODO: Do a conditional create. Currently, data source in TF azurerm provider returns a not found
#       error if azuread_service_principal doesn't exist. Hence, we need to explore using external
#       Data Source or an alternative approach.
#---------------------------------------------------------------------------------------------
resource "azuread_service_principal" "sysdig_sp" {
  client_id = var.sysdig_client_id
}

#---------------------------------------------------------------------------------------------
# Assign "Reader" role to Sysdig SP for primary subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_reader" {
  count = var.is_organizational ? 0 : 1

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Azure Kubernetes Service Cluster User Role" role to Sysdig SP for primary subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_k8s_reader" {
  count = var.is_organizational ? 0 : 1

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Virtual Machine User Login" role to Sysdig SP for primary subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_user" {
  count = var.is_organizational ? 0 : 1

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}