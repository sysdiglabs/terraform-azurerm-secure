output "service_principal_display_name" {
  value       = azuread_service_principal.sysdig_cspm_sp.display_name
  description = "Display name of the Config Posture Service Principal created"
}

output "service_principal_component_id" {
  value       = module.service-principal.service_principal_component_id
  description = "Component identifier of Config Posture Service Principal created in Sysdig Backend"
}