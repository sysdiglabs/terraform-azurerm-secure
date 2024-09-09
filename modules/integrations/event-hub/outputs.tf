output "event_hub_component_id" {
  value       = "${sysdig_secure_cloud_auth_account_component.azure_event_hub.type}/${sysdig_secure_cloud_auth_account_component.azure_event_hub.instance}"
  description = "Component identifier of Event Hub integration created in Sysdig Backend for Log Ingestion"
  depends_on = [ sysdig_secure_cloud_auth_account_component.azure_event_hub ]
}

output "event_hub_name" {
  value = azurerm_eventhub.sysdig_event_hub.name
  description = "Event Hub integration created for Sysdig Log Ingestion"
}

output "sysdig_authorization_id" {
  value = azurerm_eventhub_namespace_authorization_rule.sysdig_rule.id
  description = "Identifier of Authorization Rule for the Sysdig Namespace"
}

output "unique_deployment_id" {
  value = "${random_string.random.result}-${local.subscription_hash}"
  description = "Identifier of Deployment that gets added to provisioned resources"
}
