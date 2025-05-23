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

resource "azurerm_role_definition" "sysdig_cspm_role_aks_discovery_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  name        = "sysdig_cspm_role_for_tenant_${each.key}"
  scope       = each.key
  description = "Custom role for collecting Authsettings for CIS Benchmark"

  permissions {
    actions = local.agentless_aks_connection_permissions_actions
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
  for_each = var.is_organizational ? local.management_groups : []

  scope              = each.key
  role_definition_id = azurerm_role_definition.sysdig_cspm_role_aks_discovery_for_tenant[each.key].role_definition_resource_id
  principal_id       = var.sysdig_cspm_sp_object_id
}
