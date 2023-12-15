output "event_hub_name" {
  value       = azurerm_eventhub.sysdig_event_hub.name
  description = "Name of the newly created Event Hub"
}

output "event_hub_namespace" {
  value       = azurerm_eventhub_namespace.sysdig_event_hub_namespace.name
  description = "Name of the newly created Event Hub Namespace"
}

output "consumer_group_name" {
    value       = azurerm_eventhub_consumer_group.sysdig_consumer_group.name
    description = "Name of the newly created Event Hub Consumer Group"
}

output "subscription_alias" {
  value = data.azurerm_subscription.sysdig_subscription.display_name
  description = "Display name of the subscription"
}
