output "service_principal_component_id" {
  value       = "${sysdig_secure_cloud_auth_account_component.azure_service_principal.type}/${sysdig_secure_cloud_auth_account_component.azure_service_principal.instance}"
  description = "Component identifier of Service Principal created in Sysdig Backend for Config Posture"
  depends_on = [ sysdig_secure_cloud_auth_account_component.azure_service_principal ]
}

output "sysdig_cspm_sp_object_id" {
  value = var.config_posture_service_principal != "" ? data.azuread_service_principal.sysdig_cspm_sp[0].object_id : azuread_service_principal.sysdig_cspm_sp[0].object_id
  description = "Object ID of the CSPM SP within the client's infra"
  depends_on = [azuread_service_principal.sysdig_cspm_sp]
}