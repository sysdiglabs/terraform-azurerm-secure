output "event_hub_component_id" {
  value       = "${sysdig_secure_cloud_auth_account_component.azure_event_hub.type}/${sysdig_secure_cloud_auth_account_component.azure_event_hub.instance}"
  description = "Component identifier of Event Hub integration created in Sysdig Backend for Log Ingestion"
  depends_on = [ sysdig_secure_cloud_auth_account_component.azure_event_hub ]
}