output "service_principal_display_name" {
  value       = azuread_service_principal.sysdig_sp.display_name
  description = "Display name of the Service Principal integration created"
}

output "service_principal_component_id" {
  value       = "${sysdig_secure_cloud_auth_account_component.azure_service_principal.type}/${sysdig_secure_cloud_auth_account_component.azure_service_principal.instance}"
  description = "Component identifier of the Service Principal integration"
}