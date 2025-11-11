#---------------------------------------------------------------------------------------------
# Fetch the management groups for customer tenant and onboard subscriptions under them
#---------------------------------------------------------------------------------------------
data "azurerm_management_group" "root_management_group" {
  count        = var.is_organizational ? 1 : 0
  display_name = "Tenant Root Group"
}

locals {
  # when empty, this will be the root management group whose default display name is "Tenant root group"
  management_groups = var.is_organizational && length(var.management_group_ids) == 0 ? [data.azurerm_management_group.root_management_group[0].id] : toset(
  [for m in var.management_group_ids : format("%s/%s", "/providers/Microsoft.Management/managementGroups", m)])
}

# A random resource is used to generate unique key names.
# This prevents conflicts when creating a Workload scanning role for tenant/MGs with the same name.
# tflint-ignore: terraform_required_providers
resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}

#---------------------------------------------------------------------------------------------
# Create a custom role for accessing function app config
#---------------------------------------------------------------------------------------------
resource "azurerm_role_definition" "sysdig_vm_workload_scanning_func_app_config_role_for_tenant" {
  for_each = var.is_organizational && var.functions_enabled ? (
    local.check_old_management_group_ids_param ? local.management_groups : local.scopes_for_resources
  ) : []

  name        = "sysdig-vm-workload-scanning-function-app-reader-role-for-tenant-${random_string.random.result}-${each.key}"
  scope       = each.key
  description = "Custom role for reading function app configuration"
  permissions {
    actions     = local.vm_workload_scanning_permissions
    not_actions = []
  }
  assignable_scopes = [
    each.key,
  ]
}

#---------------------------------------------------------------------------------------------
# Assign "AcrPull" role to Sysdig Onboarding SP for customer tenant, for retrieving inventory
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_workload_scanning_acrpull_for_tenant" {
  for_each = var.is_organizational ? (
    local.check_old_management_group_ids_param ? local.management_groups : local.scopes_for_resources
  ) : []

  scope                = each.key
  role_definition_name = "AcrPull"
  principal_id         = var.vm_workload_scanning_service_principal != "" ? data.azuread_service_principal.sysdig_vm_workload_scanning_sp[0].object_id : azuread_service_principal.sysdig_vm_workload_scanning_sp[0].object_id
}

#---------------------------------------------------------------------------------------------
# Custom role assignment for accessing function app config
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_workload_scanning_func_app_config_role_assignment_for_tenant" {
  for_each = var.is_organizational && var.functions_enabled ? (
    local.check_old_management_group_ids_param ? local.management_groups : local.scopes_for_resources
  ) : []

  scope              = each.key
  role_definition_id = azurerm_role_definition.sysdig_vm_workload_scanning_func_app_config_role_for_tenant[each.key].role_definition_resource_id
  principal_id       = var.vm_workload_scanning_service_principal != "" ? data.azuread_service_principal.sysdig_vm_workload_scanning_sp[0].object_id : azuread_service_principal.sysdig_vm_workload_scanning_sp[0].object_id
}

#---------------------------------------------------------------------------------------------
# Custom role assignment for Azure functions:
# Storage File Data Privileged Reader
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_workload_scanning_file_reader_role_assignment_for_tenant" {
  for_each = var.is_organizational && var.functions_enabled ? (
    local.check_old_management_group_ids_param ? local.management_groups : local.scopes_for_resources
  ) : []

  scope              = each.key
  role_definition_id = data.azurerm_role_definition.storage_file_reader[0].role_definition_id
  principal_id       = var.vm_workload_scanning_service_principal != "" ? data.azuread_service_principal.sysdig_vm_workload_scanning_sp[0].object_id : azuread_service_principal.sysdig_vm_workload_scanning_sp[0].object_id
}

#---------------------------------------------------------------------------------------------
# Custom role assignment for Azure functions:
# Storage Blob Data Reader
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_workload_scanning_blob_reader_role_assignment_for_tenant" {
  for_each = var.is_organizational && var.functions_enabled ? (
    local.check_old_management_group_ids_param ? local.management_groups : local.scopes_for_resources
  ) : []

  scope              = each.key
  role_definition_id = data.azurerm_role_definition.storage_blob_reader[0].role_definition_id
  principal_id       = var.vm_workload_scanning_service_principal != "" ? data.azuread_service_principal.sysdig_vm_workload_scanning_sp[0].object_id : azuread_service_principal.sysdig_vm_workload_scanning_sp[0].object_id
}
