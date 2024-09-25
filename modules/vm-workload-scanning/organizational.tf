#---------------------------------------------------------------------------------------------
# Fetch the management groups for customer tenant and onboard subscriptions under them
#---------------------------------------------------------------------------------------------
data "azurerm_management_group" "root_management_group" {
  count        = var.is_organizational && length(var.management_group_ids) == 0 ? 1 : 0
  display_name = "Tenant Root Group"
}

locals {
  # when empty, this will be the root management group whose default display name is "Tenant root group"
  management_groups = var.is_organizational && length(var.management_group_ids) == 0 ? [data.azurerm_management_group.root_management_group[0].id] : toset(
    [for m in var.management_group_ids : format("%s/%s", "/providers/Microsoft.Management/managementGroups",m)])
}


#---------------------------------------------------------------------------------------------
# Create a custom role for accessing function app config
#---------------------------------------------------------------------------------------------
resource "azurerm_role_definition" "sysdig_vm_workload_scanning_func_app_config_role_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  name        = "sysdig-vm-workload-scanning-function-app-reader-role-for-tenant-${each.key}"
  scope       = each.key
  description = "Custom role for reading function app configuration"
  permissions {
    actions     = local.vm_workload_scanning_permissions
    not_actions = []
  }
  assignable_scopes = [
    each.key,
  ]
}

#---------------------------------------------------------------------------------------------
# Assign "AcrPull" role to Sysdig Onboarding SP for customer tenant, for retrieving inventory
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_workload_scanning_acrpull_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  scope                = each.key
  role_definition_name = "AcrPull"
  principal_id         = azuread_service_principal.sysdig_vm_workload_scanning_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Custom role assignment for accessing function app config
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_workload_scanning_func_app_config_role_assignment_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  scope              = each.key
  role_definition_id = azurerm_role_definition.sysdig_vm_workload_scanning_func_app_config_role_for_tenant[each.key].role_definition_resource_id
  principal_id       = azuread_service_principal.sysdig_vm_workload_scanning_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Custom role assignment for Azure functions:
# Storage File Data Privileged Reader
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_workload_scanning_file_reader_role_assignment_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  scope              = each.key
  role_definition_id = data.azurerm_role_definition.storage_file_reader.role_definition_id
  principal_id       = azuread_service_principal.sysdig_vm_workload_scanning_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Custom role assignment for Azure functions:
# Storage Blob Data Reader
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_vm_workload_scanning_blob_reader_role_assignment_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  scope              = each.key
  role_definition_id = data.azurerm_role_definition.storage_blob_reader.role_definition_id
  principal_id       = azuread_service_principal.sysdig_vm_workload_scanning_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Add Component to Cloud Auth Account for VM Workload Scanning
# (ensure it is called after all above cloud resources are created using explicit depends_on)
#---------------------------------------------------------------------------------------------

resource "sysdig_secure_cloud_auth_account_component" "azure_workload_scanning_component" {
  count = var.is_organizational ? 1 : 0

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
    sysdig_vm_workload_scanning_func_app_config_role_assignment_for_tenant,
    sysdig_vm_workload_scanning_file_reader_role_assignment_for_tenant,
    sysdig_vm_workload_scanning_blob_reader_role_assignment_for_tenant,
    sysdig_vm_workload_scanning_acrpull_for_tenant
  ]
}