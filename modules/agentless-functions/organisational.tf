#---------------------------------------------------------------------------------------------
# Fetch the management groups for customer tenant and onboard subscriptions under them
#---------------------------------------------------------------------------------------------
data "azurerm_management_group" "root_management_group" {
  count        = var.is_organizational && length(var.management_group_ids) == 0 ? 1 : 0
  display_name = "Tenant Root Group"
}

locals {
  # when empty, this will be the root management group whose default display name is "Tenant root group"
  management_groups = var.is_organizational && length(var.management_group_ids) == 0 ? [data.azurerm_management_group.root_management_group[0].id] : toset(
  [for m in var.management_group_ids : format("%s/%s", "/providers/Microsoft.Management/managementGroups", m)])
}

#---------------------------------------------------------------------------------------------
# Create a custom role for accessing function app config
#---------------------------------------------------------------------------------------------
resource "azurerm_role_definition" "func_app_config_role_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  name        = "sysdig-function-app-reader-role-for-tenant-${each.key}"
  scope       = each.key
  description = "Custom role for reading function app configuration"
  permissions {
    actions     = local.agentless_workload_permissions
    not_actions = []
  }
  assignable_scopes = [
    each.key,
  ]
}

#---------------------------------------------------------------------------------------------
# Custom role assignment for accessing function app config
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "func_app_config_role_assignment_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  scope              = each.key
  role_definition_id = azurerm_role_definition.func_app_config_role_for_tenant[each.key].role_definition_resource_id
  principal_id       = data.azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Custom role assignment for Azure functions:
# Storage File Data Privileged Reader
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_file_reader_role_assignment_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  scope              = each.key
  role_definition_id = azurerm_role_definition.storage_file_reader.role_definition_id
  principal_id       = data.azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Custom role assignment for Azure functions:
# Storage Blob Data Reader
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_blob_reader_role_assignment_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  scope              = each.key
  role_definition_id = azurerm_role_definition.storage_blob_reader.role_definition_id
  principal_id       = data.azuread_service_principal.sysdig_sp.object_id
}

