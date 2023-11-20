data "azurerm_subscriptions" "available" {}

locals { 
    enabled_subscriptions = var.is_organizational ? [for s in data.azurerm_subscriptions.available.subscriptions : s if s.state == "Enabled"] : []
}

#---------------------------------------------------------------------------------------------
# Create diagnostic settings for the tenant
#---------------------------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "sysdig_org_diagnostic_setting" {
  count = var.is_organizational ? length(local.enabled_subscriptions) : 0

  name               = "sysdig-diagnostic-setting"
  target_resource_id = local.enabled_subscriptions[count.index].id
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.sysdig_rule.id
  eventhub_name                  = azurerm_eventhub.sysdig_event_hub.name

  enabled_log {
    category = "Administrative"
  }

  enabled_log {
    category = "Security"
  }

  enabled_log {
    category = "ServiceHealth"
  }

  enabled_log {
    category = "Alert"
  }

  enabled_log {
    category = "Recommendation"
  }

  enabled_log {
    category = "Policy"
  }

  enabled_log {
    category = "Autoscale"
  }

  enabled_log {
    category = "ResourceHealth"
  }
}
