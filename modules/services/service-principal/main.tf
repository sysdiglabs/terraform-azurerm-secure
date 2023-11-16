provider "azurerm" {
  features {}
}

data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

#---------------------------------------------------------------------------------------------
# Create service principal in customer tenant
#---------------------------------------------------------------------------------------------
resource "azuread_service_principal" "sysdig_sp" {
  client_id = var.sysdig_application_id
}

#---------------------------------------------------------------------------------------------
# Assign "Reader" role to Sysdig SP for primary subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_reader" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Azure Kubernetes Service Cluster User Role" role to Sysdig SP for primary subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_k8s_reader" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Virtual Machine User Login" role to Sysdig SP for primary subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_user" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}