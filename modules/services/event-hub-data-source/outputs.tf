output "event_hub_name" {
  value       = azurerm_eventhub.sysdig_event_hub.name
  description = "Name of the newly created Event Hub"
}

output "event_hub_namespace" {
  value       = azurerm_eventhub_namespace.sysdig_event_hub_namespace.name
  description = "Name of the newly created Event Hub Namespace"
}
output "consumer_group_name" {
    value       = azurerm_eventhub_consumer_group.sysdig_consumer_group.name
    description = "Name of the newly created Event Hub Consumer Group"
}

output "subscription_alias" {
  value = data.azurerm_subscription.sysdig_subscription.display_name
  description = "Display name of the subscription"
}

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