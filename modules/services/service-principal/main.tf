provider "azurerm" {
  features {}
}

data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

#---------------------------------------------------------------------------------------------
# Create service principal in customer tenant
#
# If there is an existing service principal in the tenant, this will automatically import
# and use it, ensuring we have just one service principal linked to the Sysdig application
# in the customer tenant.
# Note: Please refer to the caveats of use_existing attribute for this resource.
#
# Note: Once created, this cannot be deleted via Terraform. It can be manually deleted from Azure.
#       This is to safeguard against unintended deletes if the service principal is in use.
#---------------------------------------------------------------------------------------------
resource "azuread_service_principal" "sysdig_sp" {
  client_id    = var.sysdig_client_id
  use_existing = true
  lifecycle {
    prevent_destroy = true
  }
}

#---------------------------------------------------------------------------------------------
# Assign "Directory Reader" AD role to Sysdig SP
#---------------------------------------------------------------------------------------------
resource "azuread_directory_role_assignment" "sysdig_ad_reader" {
  role_id             = "88d8e3e3-8f55-4a1e-953a-9b9898b8876b" // template ID of Directory Reader AD role
  principal_object_id = azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Reader" role to Sysdig SP for primary subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_reader" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Azure Kubernetes Service Cluster User Role" role to Sysdig SP for primary subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_k8s_reader" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Virtual Machine User Login" role to Sysdig SP for primary subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_user" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = azuread_service_principal.sysdig_sp.object_id
}