#---------------------------------------------------------------------------------------------
# Fetch the management groups for customer tenant and onboard subscriptions under them
#---------------------------------------------------------------------------------------------
data "azurerm_management_group" "root_management_group" {
  count  = var.is_organizational && length(var.management_group_ids) == 0 ? 1 : 0
  display_name = "Tenant Root Group"
}

locals {
  # when empty, this will be the root management group whose default display name is "Tenant root group"
  management_groups = var.is_organizational && length(var.management_group_ids) == 0 ? [data.azurerm_management_group.root_management_group[0].id] : toset(
    [for m in var.management_group_ids : format("%s/%s", "/providers/Microsoft.Management/managementGroups",m)])
}

#---------------------------------------------------------------------------------------------
# Assign "Reader" role to Sysdig SP for customer tenant
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_reader_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  scope                = each.key
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Azure Kubernetes Service Cluster User Role" role to Sysdig SP for customer tenant
#---------------------------------------------------------------------------------------------
/*
resource "azurerm_role_assignment" "sysdig_k8s_reader_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  scope                = each.key
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Virtual Machine User Login" role to Sysdig SP for customer tenant
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_user_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  scope                = each.key
  role_definition_name = "Virtual Machine User Login"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
<<<<<<< HEAD
}
=======
}*/
