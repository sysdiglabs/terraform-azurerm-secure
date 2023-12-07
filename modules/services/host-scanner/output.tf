output "lighthouse_definition_display_id" {
  value       = azurerm_lighthouse_definition.lighthouse_definition.id
  description = "Display id of the Light House definition created"
}

output "lighthouse_assignment_display_id" {
  value       = azurerm_lighthouse_assignment.lighthouse_assignment.id
  description = "Display id of the Light House assignment created"
}
