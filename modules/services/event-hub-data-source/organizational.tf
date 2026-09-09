data "azurerm_client_config" "current" {}

data "azurerm_management_group" "onboarded_management_group" {
  for_each = var.is_organizational && length(var.management_group_ids) > 0 ? toset(var.management_group_ids) : toset([])
  name     = each.value
}

data "azurerm_management_group" "root_management_group" {
  count        = var.is_organizational && length(var.management_group_ids) == 0 ? 1 : 0
  display_name = "Tenant Root Group"
}

locals {
  selected_management_group = var.is_organizational ? (length(data.azurerm_management_group.onboarded_management_group) > 0 ? values(data.azurerm_management_group.onboarded_management_group) : [data.azurerm_management_group.root_management_group[0]]) : []
  all_mg_subscription_ids = flatten([
    for mg in local.selected_management_group : mg.all_subscription_ids
  ])
}

data "azurerm_subscription" "onboarded_subscriptions" {
  for_each        = var.is_organizational && length(local.all_mg_subscription_ids) > 0 ? toset(local.all_mg_subscription_ids) : toset([])
  subscription_id = each.value
}

locals {
  enabled_subscriptions = var.is_organizational ? {
    for k, s in data.azurerm_subscription.onboarded_subscriptions : k => s if s.state == "Enabled"
  } : {}
}

#---------------------------------------------------------------------------------------------
# Create diagnostic settings for the tenant
#---------------------------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "sysdig_org_diagnostic_setting" {
  for_each = local.enabled_subscriptions

  name                           = "${var.diagnostic_settings_name}-${local.subscription_hash}"
  target_resource_id             = each.value.id
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.sysdig_rule.id
  eventhub_name                  = azurerm_eventhub.sysdig_event_hub.name

  enabled_log {
    category = "Administrative"
  }

  enabled_log {
    category = "Security"
  }

  enabled_log {
    category = "Policy"
  }
}
