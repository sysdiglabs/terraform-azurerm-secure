data "azurerm_management_group" "root_management_group" {
  count        = var.is_organizational && length(var.management_group_ids) == 0 ? 1 : 0
  display_name = "Tenant Root Group"
}

data "azurerm_management_group" "management_groups" {
  for_each = var.is_organizational && length(var.management_group_ids) > 0 ? var.management_group_ids : []
  name     = each.value
}

locals {
  subscriptions = toset(var.is_organizational && length(var.management_group_ids) == 0 ? data.azurerm_management_group.root_management_group[0].all_subscription_ids :
    (var.is_organizational ? flatten([for m in data.azurerm_management_group.management_groups : m.all_subscription_ids]) : var.subscription_id))
}