# M2
resource "azurerm_monitor_diagnostic_setting" "sysdig_custom_diagnostics" {
  for_each                       = var.diagnostic_settings
  name                           = "sysdig-diagnostic-settings-${substr(md5(each.key), 0, 8)}-${var.deployment_identifier}"
  target_resource_id             = each.key
  eventhub_authorization_rule_id = var.sysdig_authorization_id
  eventhub_name                  = var.event_hub_name

  dynamic "enabled_log" {
    for_each = each.value
    content {
      category = enabled_log.value
    }
  }
}
