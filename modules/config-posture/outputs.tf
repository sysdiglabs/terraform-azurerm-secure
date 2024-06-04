output "service_principal_display_name" {
  value       = azuread_service_principal.sysdig_cspm_sp.display_name
  description = "Display name of the Service Principal created used for Config Posture"
}

output "service_principal_component_id" {
  value       = "${sysdig_secure_cloud_auth_account_component.azure_service_principal.type}/${sysdig_secure_cloud_auth_account_component.azure_service_principal.instance}"
  description = "Component identifier of Service Principal created in Sysdig Backend for Config Posture"
}