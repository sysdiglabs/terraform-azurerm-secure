#---------------------------------------------------------------------------------------------
# Fetch the management groups for customer tenant and onboard subscriptions under them
#---------------------------------------------------------------------------------------------
# If no management group is present, then the root management group is used to onboard all the subscriptions
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
  flatten([for m in data.azurerm_management_group.management_groups : m.all_subscription_ids]))
}

data "azurerm_subscription" "all_subscriptions" {
  for_each = toset(local.subscriptions)
  subscription_id = each.value
}

# Filter only the enabled subscriptions
locals {
  enabled_subscription_ids = [
    for s in data.azurerm_subscription.all_subscriptions :
    s.subscription_id if s.state == "Enabled"
  ]
}

resource "azurerm_lighthouse_assignment" "lighthouse_assignment_for_tenant" {
  for_each = var.is_organizational ? toset(local.enabled_subscription_ids) : toset([])

  scope                    = "/subscriptions/${each.value}"
  lighthouse_definition_id = azurerm_lighthouse_definition.lighthouse_definition.id
}
