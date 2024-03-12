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

resource "azurerm_lighthouse_definition" "lighthouse_definition_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  provider           = azurerm.subscription
  name               = "Sysdig Agentless Host Scanner"
  description        = "Lighthouse definition for Sysdig Agentless Host Scanner"
  managing_tenant_id = var.sysdig_tenant_id
  scope              = each.key
  authorization {
    principal_id           = var.sysdig_service_principal_id
    principal_display_name = "Sysdig Service Principal Agentless Host Scanner"
    # Uses VM Scanner Operator role
    role_definition_id = "d24ecba3-c1f4-40fa-a7bb-4588a071e8fd"
  }
}

resource "azurerm_lighthouse_assignment" "lighthouse_assignment_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  provider                 = azurerm.subscription
  scope                    = each.key
  lighthouse_definition_id = azurerm_lighthouse_definition.lighthouse_definition.id
}