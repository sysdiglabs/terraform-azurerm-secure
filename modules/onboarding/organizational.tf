#---------------------------------------------------------------------------------------------
# Fetch the management groups for customer tenant and onboard subscriptions under them
#---------------------------------------------------------------------------------------------
data "azurerm_management_group" "root_management_group" {
  count        = var.is_organizational ? 1 : 0
  display_name = "Tenant Root Group"
}

#---------------------------------------------------------------------------------------------
# Assign "Reader" role to Sysdig Onboarding SP for customer tenant, for retrieving inventory
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_onboarding_reader_for_tenant" {
  for_each = var.is_organizational && !(var.use_existing_role_assignments && var.onboarding_service_principal != "") ? toset(local.scopes_for_resources) : []

  scope                = each.key
  role_definition_name = "Reader"
  principal_id         = var.onboarding_service_principal != "" ? data.azuread_service_principal.sysdig_onboarding_sp[0].object_id : azuread_service_principal.sysdig_onboarding_sp[0].object_id
}

#---------------------------------------------------------------------------------------------
# Call Sysdig Backend to create organization with foundational onboarding
# (ensure it is called after all above cloud resources are created)
#---------------------------------------------------------------------------------------------
resource "sysdig_secure_organization" "azure_organization" {
  count = var.is_organizational ? 1 : 0

  management_account_id          = sysdig_secure_cloud_auth_account.azure_account.id
  organization_root_id           = var.tenant_id
  included_organizational_groups = var.include_management_groups
  excluded_organizational_groups = var.exclude_management_groups
  included_cloud_accounts        = var.include_subscriptions
  excluded_cloud_accounts        = var.exclude_subscriptions
  automatic_onboarding           = var.enable_automatic_onboarding
  depends_on                     = [azurerm_role_assignment.sysdig_onboarding_reader_for_tenant]

  lifecycle {
    ignore_changes = [automatic_onboarding]
  }
}
