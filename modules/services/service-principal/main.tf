provider "azurerm" {
  features {}
}

data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

#---------------------------------------------------------------------------------------------
# Create service principal in customer tenant
#---------------------------------------------------------------------------------------------
resource "azuread_service_principal" "sysdig_sp" {
  # Using Sysdig's application ID in sysdigqatenant tenant.
  # TODO: use application id from sysdig tenant
  application_id = var.sysdig_application_id
  display_name   = "Service principal for secure posture management"
}

#---------------------------------------------------------------------------------------------
# Assign "Reader" role to Sysdig SP for primary subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_reader" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}