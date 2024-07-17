output "lighthouse_definition_display_id" {
  value       = azurerm_lighthouse_definition.lighthouse_definition.id
  description = "Display id of the Light House definition created"
}

output "service_principal_component_id" {
  value       = "${sysdig_secure_cloud_auth_account_component.azure_service_principal.type}/${sysdig_secure_cloud_auth_account_component.azure_service_principal.instance}"
  description = "Component identifier of Service Principal created in Sysdig Backend for Agentless Scanning"
  depends_on = [ sysdig_secure_cloud_auth_account_component.azure_service_principal ]
}