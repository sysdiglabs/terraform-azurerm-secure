output "service_principal_display_name" {
  value       = azuread_service_principal.sysdig_cdr_sp.display_name
  description = "Display name of the Threat Detection Service Principal created"
}

output "event_hub_component_id" {
  value       = module.event-hub.event_hub_component_id
  description = "Component identifier of Event Hub created in Sysdig Backend for Log Ingestion"
}