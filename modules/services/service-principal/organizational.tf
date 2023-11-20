#---------------------------------------------------------------------------------------------
# Fetch the root management group for customer tenant
# By default, the root management group's display name is "Tenant root group"
#---------------------------------------------------------------------------------------------
data "azurerm_management_group" "root" {
  count  = var.is_organizational ? 1 : 0
  display_name = "Tenant Root Group"
}

#---------------------------------------------------------------------------------------------
# Assign "Reader" role to Sysdig SP for customer tenant
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_reader" {
  count  = var.is_organizational ? 1 : 0

  scope                = data.azurerm_management_group.root.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Azure Kubernetes Service Cluster User Role" role to Sysdig SP for customer tenant
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_k8s_reader" {
  count  = var.is_organizational ? 1 : 0

  scope                = data.azurerm_management_group.root.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Virtual Machine User Login" role to Sysdig SP for customer tenant
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_user" {
  count  = var.is_organizational ? 1 : 0

  scope                = data.azurerm_management_group.root.id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}