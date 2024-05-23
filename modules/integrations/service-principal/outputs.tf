output "service_principal_component_id" {
  value       = "${sysdig_secure_cloud_auth_account_component.azure_service_principal.type}/${sysdig_secure_cloud_auth_account_component.azure_service_principal.instance}"
  description = "Component identifier of the Service Principal integration"
}