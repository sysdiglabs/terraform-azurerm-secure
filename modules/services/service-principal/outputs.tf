output "service_principal_display_name" {
  value       = azuread_service_principal.sysdig_sp.display_name
  description = "Display name of the Service Principal created"
}

output "service_principal_application_id" {
  value       = azuread_service_principal.sysdig_sp.application_id
  description = "Application ID of the Service Principal created"
}
output "service_principal_id" {
    value       = azuread_service_principal.sysdig_sp.id
    description = "Service Principal ID on the customer tenant"
}

output "subscription_tenant_id" {
    value       = data.azurerm_subscription.primary.tenant_id
    description = "Tenant ID of the Subscription"
}