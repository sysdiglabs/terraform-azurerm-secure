output "service_principal_display_name" {
  value       = azuread_service_principal.sysdig_sp.display_name
  description = "Display name of the Service Principal created"
}

output "service_principal_client_id" {
  value       = azuread_service_principal.sysdig_sp.client_id
  description = "Client ID of the Service Principal created"
}
output "service_principal_id" {
    value       = azuread_service_principal.sysdig_sp.id
    description = "Service Principal ID on the customer tenant"
}

output "service_principal_app_display_name" {
    value       = azuread_service_principal.sysdig_sp.display_name
    description = "Display name of the Application created"
}

output "service_principal_app_owner_organization_id" {
    value       = azuread_service_principal.sysdig_sp.application_tenant_id
    description = "Organization ID of the Application created"
}

output "subscription_tenant_id" {
  value       = data.azurerm_subscription.primary.tenant_id
  description = "Tenant ID of the Subscription"
}

output "subscription_alias" {
  value = data.azurerm_subscription.primary.display_name
  description = "Display name of the subscription"
}