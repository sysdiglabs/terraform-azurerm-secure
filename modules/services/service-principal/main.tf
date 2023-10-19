provider "azurerm" {
  skip_provider_registration = true
  use_cli = false
  features {}
}

provider "azuread" {
  use_cli = false
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
  application_id = "0a800625-0e0d-4805-827c-743371e8518c"
}

#---------------------------------------------------------------------------------------------
# Assign "Reader" role to Sysdig SP for primary subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_reader" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}