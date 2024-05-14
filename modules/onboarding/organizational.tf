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
# Assign "Reader" role to Sysdig Onboarding SP for customer tenant, for retrieving inventory
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_onboarding_reader_for_tenant" {
  for_each = var.is_organizational ? local.management_groups : []

  scope                = each.key
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.sysdig_onboarding_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Call Sysdig Backend to create organization with foundational onboarding
# (ensure it is called after all above cloud resources are created)
#---------------------------------------------------------------------------------------------
resource "sysdig_secure_organization" "azure_organization" {
  count = var.is_organizational ? 1 : 0

  management_account_id   = sysdig_secure_cloud_auth_account.azure_account.id
  organizational_unit_ids = var.management_group_ids
  depends_on              = [azurerm_role_assignment.sysdig_onboarding_reader_for_tenant]
}