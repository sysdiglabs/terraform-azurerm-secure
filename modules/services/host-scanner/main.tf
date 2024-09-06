data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

resource "azurerm_lighthouse_definition" "lighthouse_definition" {
  name               = "Sysdig Agentless Host Scanner"
  description        = "Lighthouse definition for Sysdig Agentless Host Scanner"
  managing_tenant_id = var.sysdig_tenant_id
  scope              = "/subscriptions/${var.subscription_id}"
  authorization {
    principal_id           = var.sysdig_service_principal_id
    principal_display_name = "Sysdig Service Principal Agentless Host Scanner"
    # Uses VM Scanner Operator role
    role_definition_id = "d24ecba3-c1f4-40fa-a7bb-4588a071e8fd"
  }
}

resource "azurerm_lighthouse_assignment" "lighthouse_assignment" {
  count                    = var.is_organizational ? 0 : 1
  scope                    = "/subscriptions/${var.subscription_id}"
  lighthouse_definition_id = azurerm_lighthouse_definition.lighthouse_definition.id
}
