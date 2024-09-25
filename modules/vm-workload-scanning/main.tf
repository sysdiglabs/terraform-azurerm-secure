data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

data "sysdig_secure_trusted_azure_app" "vm_workload_scanning" {
  name = "vm_workload_scanning"
}

#---------------------------------------------------------------------------------------------------
# Create service principal in customer tenant, using the Sysdig Managed Application for VM Agentless
#
# If there is an existing service principal in the tenant, this will automatically import
# and use it, ensuring we have just one service principal linked to the Sysdig application
# in the customer tenant.
# Note: Please refer to the caveats of use_existing attribute for this resource.
#
# Note: Once created, this cannot be deleted via Terraform. It can be manually deleted from Azure.
#       This is to safeguard against unintended deletes if the service principal is in use.
#----------------------------------------------------------------------------------------------------
resource "azuread_service_principal" "sysdig_vm_workload_scanning_sp" {
  client_id    = data.sysdig_secure_trusted_azure_app.vm_workload_scanning.application_id
  use_existing = true
  notes        = "Service Principal linked to the Sysdig Secure CNAPP - VM Agentless Workload module"
}

#---------------------------------------------------------------------------------------------
# Roles & Permissions
#---------------------------------------------------------------------------------------------

locals {
  vm_workload_scanning_permissions = [
    "Microsoft.Web/sites/config/list/Action",
    "microsoft.web/sites/config/appsettings/read",
    "Microsoft.Web/sites/publish/Action"
  ]
}

data "azurerm_role_definition" "storage_file_reader" {
  name = "Storage File Data Privileged Reader"
}

data "azurerm_role_definition" "storage_blob_reader" {
  name = "Storage Blob Data Reader"
}

resource "azurerm_role_definition" "sysdig_vm_workload_scanning_func_app_config_role" {
  count = var.is_organizational ? 0 : 1

  name        = "sysdig-vm-workload-scanning-workload-function-app-reader-role-${var.subscription_id}"
  scope       = data.azurerm_subscription.primary.id
  description = "Custom role for reading function app configuration"
  permissions {
    actions     = local.vm_workload_scanning_permissions
    not_actions = []
  }
  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}

#---------------------------------------------------------------------------------------------
# Assign custom permissions to Sysdig Vm Agentless Workload SP for Accessing AppConfig and Determining where Azure Functions Code is located
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_workload_scanning_func_app_config_role_assignment" {
  count = var.is_organizational ? 0 : 1

  scope              = data.azurerm_subscription.primary.id
  role_definition_id = azurerm_role_definition.sysdig_vm_workload_scanning_func_app_config_role.role_definition_resource_id
  principal_id         = azuread_service_principal.sysdig_vm_workload_scanning_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Storage File Data Privileged Reader" role to Sysdig Vm Agentless Workload SP for Accessing Azure Functions Code
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_workload_scanning_file_reader_role_assignment" {
  count = var.is_organizational ? 0 : 1

  scope              = data.azurerm_subscription.primary.id
  role_definition_id = data.azurerm_role_definition.storage_file_reader.role_definition_id
  principal_id         = azuread_service_principal.sysdig_vm_workload_scanning_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Assign "Storage Blob Data Reader" role to Sysdig Vm Agentless Workload SP for Accessing Azure Functions Code
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_workload_scanning_blob_reader_role_assignment" {
  count = var.is_organizational ? 0 : 1

  scope              = data.azurerm_subscription.primary.id
  role_definition_id = data.azurerm_role_definition.storage_blob_reader.role_definition_id
  principal_id         = azuread_service_principal.sysdig_vm_workload_scanning_sp.object_id
}

#-------------------------------------------------------------------------------------------------
# Assign "AcrPull" role to Sysdig Vm Agentless Workload SP for primary subscription, for retrieving inventory
#-------------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_workload_scanning_acrpull_assignment" {
  count = var.is_organizational ? 0 : 1

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "AcrPull"
  principal_id         = azuread_service_principal.sysdig_vm_workload_scanning_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Add Component to Cloud Auth Account for VM Workload Scanning
# (ensure it is called after all above cloud resources are created using explicit depends_on)
#---------------------------------------------------------------------------------------------

resource "sysdig_secure_cloud_auth_account_component" "azure_workload_scanning_component" {
  account_id                 = var.sysdig_secure_account_id
  type                       = "COMPONENT_VM_WORKLOAD_SCANNING"
  instance                   = "secure-vm-workload-scanning"
  service_principal_metadata = jsonencode({
    azure = {
      active_directory_service_principal = {
        account_enabled           = true
        display_name              = azuread_service_principal.sysdig_vm_workload_scanning_sp.display_name
        id                        = azuread_service_principal.sysdig_vm_workload_scanning_sp.id
        app_display_name          = azuread_service_principal.sysdig_vm_workload_scanning_sp.display_name
        app_id                    = azuread_service_principal.sysdig_vm_workload_scanning_sp.client_id
        app_owner_organization_id = azuread_service_principal.sysdig_vm_workload_scanning_sp.application_tenant_id
      }
    }
  })

  depends_on = [
    sysdig_vm_workload_scanning_func_app_config_role_assignment,
    sysdig_vm_workload_scanning_file_reader_role_assignment,
    sysdig_vm_workload_scanning_blob_reader_role_assignment,
    sysdig_vm_workload_scanning_acrpull_assignment,
    sysdig_vm_workload_scanning_func_app_config_role_assignment_for_tenant,
    sysdig_vm_workload_scanning_file_reader_role_assignment_for_tenant,
    sysdig_vm_workload_scanning_blob_reader_role_assignment_for_tenant,
    sysdig_vm_workload_scanning_acrpull_for_tenant
  ]
}