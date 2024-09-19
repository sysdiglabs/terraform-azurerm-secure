locals {
  agentless_workload_permissions = [
    "Microsoft.Web/sites/config/list/Action",
    "microsoft.web/sites/config/appsettings/read",
    "Microsoft.Web/sites/publish/Action"
  ]
}

data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

// Service principal created by Sysdig in the previous installation
data "azuread_service_principal" "sysdig_sp" {
  object_id = var.service_principal_id
}

data "azurerm_role_definition" "storage_file_reader" {
  name = "Storage File Data Privileged Reader"
}

data "azurerm_role_definition" "storage_blob_reader" {
  name = "Storage Blob Data Reader"
}

#---------------------------------------------------------------------------------------------
# Create a custom role for accessing function app config
#---------------------------------------------------------------------------------------------
resource "azurerm_role_definition" "func_app_config_role" {
  name        = "sysdig-function-app-reader-role-${var.subscription_id}"
  scope       = data.azurerm_subscription.primary.id
  description = "Custom role for reading function app configuration"
  permissions {
    actions     = local.agentless_workload_permissions
    not_actions = []
  }
  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}

#---------------------------------------------------------------------------------------------
# Custom role assignment for accessing function app config
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "func_app_config_role_assignment" {
  scope              = data.azurerm_subscription.primary.id
  role_definition_id = azurerm_role_definition.func_app_config_role.role_definition_resource_id
  principal_id       = data.azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Custom role assignment for Azure functions:
# Storage File Data Privileged Reader
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_file_reader_role_assignment" {
  scope              = data.azurerm_subscription.primary.id
  role_definition_id = azurerm_role_definition.storage_file_reader.role_definition_id
  principal_id       = data.azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Custom role assignment for Azure functions:
# Storage Blob Data Reader
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_blob_reader_role_assignment" {
  scope              = data.azurerm_subscription.primary.id
  role_definition_id = azurerm_role_definition.storage_blob_reader.role_definition_id
  principal_id       = data.azuread_service_principal.sysdig_sp.object_id
}

