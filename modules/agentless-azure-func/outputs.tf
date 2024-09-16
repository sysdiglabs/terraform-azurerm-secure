output "service_principal_display_name" {
  value       = data.azuread_service_principal.sysdig_sp.display_name
  description = "Display name of the customer's Service Principal"
}

output "service_principal_id" {
  value       = data.azuread_service_principal.sysdig_sp.id
  description = "Service Principal ID in the customer's tenant"
}

output "service_principal_app_owner_organization_id" {
  value       = data.azuread_service_principal.sysdig_sp.application_tenant_id
  description = "Tenant ID of the Service Principal"
}

output "subscription_tenant_id" {
  value       = data.azurerm_subscription.primary.tenant_id
  description = "Tenant ID of the Subscription"
}

output "subscription_alias" {
  value       = data.azurerm_subscription.primary.display_name
  description = "Display name of the subscription"
}

