output "lighthouse_definition_display_id" {
  value       = azurerm_lighthouse_definition.lighthouse_definition.id
  description = "Display id of the Light House definition created"
}

output "subscription_alias" {
  value = data.azurerm_subscription.primary.display_name
  description = "Display name of the subscription"
}
