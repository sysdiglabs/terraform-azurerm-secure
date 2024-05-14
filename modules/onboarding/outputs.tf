output "service_principal_display_name" {
  value       = azuread_service_principal.sysdig_onboarding_sp.display_name
  description = "Display name of the Service Principal created for onboarding"
}

output "sysdig_secure_account_id" {
  value       = sysdig_secure_cloud_auth_account.azure_account.id
  description = "ID of the Sysdig Cloud Account created"
}