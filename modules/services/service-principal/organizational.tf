#---------------------------------------------------------------------------------------------
# Fetch the management group for customer tenant and onboard subscriptions under it
#---------------------------------------------------------------------------------------------
data "azurerm_management_group" "sysdig_management_group" {
  count  = var.is_organizational ? 1 : 0
  display_name = var.management_group
}

#---------------------------------------------------------------------------------------------
# Assign "Reader" role to Sysdig SP for customer tenant
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_reader_for_tenant" {
  count  = var.is_organizational ? 1 : 0

  scope                = data.azurerm_management_group.sysdig_management_group[0].id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Azure Kubernetes Service Cluster User Role" role to Sysdig SP for customer tenant
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_k8s_reader_for_tenant" {
  count  = var.is_organizational ? 1 : 0

  scope                = data.azurerm_management_group.sysdig_management_group[0].id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Virtual Machine User Login" role to Sysdig SP for customer tenant
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_user_for_tenant" {
  count  = var.is_organizational ? 1 : 0

  scope                = data.azurerm_management_group.sysdig_management_group[0].id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}