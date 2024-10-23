output "service_principal_component_id" {
  value       = "${sysdig_secure_cloud_auth_account_component.azure_service_principal.type}/${sysdig_secure_cloud_auth_account_component.azure_service_principal.instance}"
  description = "Component identifier of Service Principal created in Sysdig Backend for Config Posture"
  depends_on = [ sysdig_secure_cloud_auth_account_component.azure_service_principal ]
}

output "sysdig_cspm_sp_object_id" {
  value = azuread_service_principal.sysdig_cspm_sp.object_id
  description = "Object ID of the CSPM SP within the client's infra"
  depends_on = [azuread_service_principal.sysdig_cspm_sp]
}

output "sysdig_cspm_sp_display_name" {
  value = azuread_service_principal.sysdig_cspm_sp.display_name
  description = "Display name of the CSPM SP within the client's infra"
  depends_on = [azuread_service_principal.sysdig_cspm_sp]
}

output "sysdig_cspm_sp_client_id" {
  value = azuread_service_principal.sysdig_cspm_sp.client_id
  description = "Client ID of the CSPM SP within the client's infra"
  depends_on = [azuread_service_principal.sysdig_cspm_sp]
}

output "sysdig_cspm_sp_application_tenant_id" {
  value = azuread_service_principal.sysdig_cspm_sp.application_tenant_id
  description = "Application Tenant ID of the CSPM SP within the client's infra"
  depends_on = [azuread_service_principal.sysdig_cspm_sp]
}
