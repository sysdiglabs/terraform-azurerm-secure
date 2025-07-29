data "azurerm_client_config" "current" {}

data "azurerm_management_group" "onboarded_management_group" {
  for_each = var.is_organizational && length(var.management_group_ids) > 0 ? toset(var.management_group_ids) : toset([])
  name     = each.value
}

data "azurerm_management_group" "root_management_group" {
  count        = var.is_organizational ? 1 : 0
  display_name = "Tenant Root Group"
}



data "azurerm_subscription" "onboarded_subscriptions" {
  for_each        = var.is_organizational && length(local.all_mg_subscription_ids) > 0 ? toset(local.all_mg_subscription_ids) : toset([])
  subscription_id = each.value
}

locals {
  enabled_subscriptions = var.is_organizational ? [for s in data.azurerm_subscription.onboarded_subscriptions : s if s.state == "Enabled"] : []
}

#---------------------------------------------------------------------------------------------
# create diagnostic settings for the tenant
#---------------------------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "sysdig_org_diagnostic_setting" {
  count = var.is_organizational ? length(local.enabled_subscriptions) : 0

  name                           = "${var.diagnostic_settings_name}-${substr(md5(local.enabled_subscriptions[count.index].id), 0, 8)}"
  target_resource_id             = local.enabled_subscriptions[count.index].id
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.sysdig_rule.id
  eventhub_name                  = azurerm_eventhub.sysdig_event_hub.name

  dynamic "enabled_log" {
    for_each = var.enabled_platform_logs
    content {
      category = enabled_log.value
    }
  }
}
