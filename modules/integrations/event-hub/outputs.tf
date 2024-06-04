output "service_principal_display_name" {
  value       = azuread_service_principal.sysdig_event_hub_sp.display_name
  description = "Display name of the Service Principal created used for Event Hub integration"
}

output "event_hub_component_id" {
  value       = "${sysdig_secure_cloud_auth_account_component.azure_event_hub.type}/${sysdig_secure_cloud_auth_account_component.azure_event_hub.instance}"
  description = "Component identifier of Event Hub integration created in Sysdig Backend for Log Ingestion"
}