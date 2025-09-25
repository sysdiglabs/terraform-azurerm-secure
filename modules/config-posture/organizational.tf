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
# This prevents conflicts when creating a CSPM role for tenant/MGs with the same name.
# tflint-ignore: terraform_required_providers
resource "random_string" "organizational_random" {
  length  = 4
  special = false
  upper   = false
}
#---------------------------------------------------------------------------------------------
# Assign "Reader" role to Sysdig SP for customer tenant
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_reader_for_tenant" {

  for_each = var.is_organizational && !(var.use_existing_role_assignments && var.config_posture_service_principal != "") ? (local.check_old_management_group_ids_param ? local.management_groups : local.scopes_for_resources) : []

  scope                = each.key
  role_definition_name = "Reader"
  principal_id         = var.config_posture_service_principal != "" ? data.azuread_service_principal.sysdig_cspm_sp[0].object_id : azuread_service_principal.sysdig_cspm_sp[0].object_id
}

#---------------------------------------------------------------------------------------------
# Create a Custom role for collecting authsettings
#---------------------------------------------------------------------------------------------
resource "azurerm_role_definition" "sysdig_cspm_role_for_tenant" {
  for_each = var.is_organizational ? (
    local.check_old_management_group_ids_param ? local.management_groups : local.scopes_for_resources
  ) : []

  name        = "sysdig_cspm_role_for_tenant_${random_string.organizational_random.result}_${each.key}"
  scope       = each.key
  description = "Custom role for collecting Authsettings for CIS Benchmark"

  permissions {
    actions = [
      "Microsoft.Web/sites/config/list/action"
    ]
    not_actions = []
  }

  assignable_scopes = [
    each.key,
  ]
}

#---------------------------------------------------------------------------------------------
# Custom role assignment for collecting authsettings
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_cspm_role_assignment_for_tenant" {
  for_each = var.is_organizational ? (local.check_old_management_group_ids_param ? local.management_groups : local.scopes_for_resources) : []

  scope              = each.key
  role_definition_id = azurerm_role_definition.sysdig_cspm_role_for_tenant[each.key].role_definition_resource_id
  principal_id       = var.config_posture_service_principal != "" ? data.azuread_service_principal.sysdig_cspm_sp[0].object_id : azuread_service_principal.sysdig_cspm_sp[0].object_id
}
