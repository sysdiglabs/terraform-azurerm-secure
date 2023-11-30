output "event_hub_name" {
  value       = azurerm_eventhub.sysdig_event_hub.name
  description = "Name of the Event Hub created"
}

output "event_hub_namespace" {
  value       = azurerm_eventhub_namespace.sysdig_event_hub_namespace.name
  description = "Name of the Event Hub Namespace created"
}
output "consumer_group_name" {
    value       = azurerm_eventhub_consumer_group.sysdig_consumer_group.name
    description = "Name of the Event Hub Consumer Group created"
}
