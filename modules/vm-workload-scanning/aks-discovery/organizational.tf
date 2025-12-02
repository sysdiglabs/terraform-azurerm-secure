#---------------------------------------------------------------------------------------------
# fetch the management groups for customer tenant and onboard subscriptions under them
#---------------------------------------------------------------------------------------------
data "azurerm_management_group" "root_management_group" {
  count        = var.is_organizational ? 1 : 0
  display_name = "Tenant Root Group"
}

# A random resource is used to generate unique key names.
# This prevents conflicts when creating an AKS discovery CSPM role for tenant/MGs with the same name.
# tflint-ignore: terraform_required_providers


resource "azurerm_role_definition" "sysdig_cspm_role_aks_discovery_for_tenant" {
  for_each = var.is_organizational ? local.scopes_for_resources : []

  name        = "sysdig_cspm_role_aks_discovery_for_tenant_${random_string.random.result}_${each.key}"
  scope       = each.key
  description = "Custom role for collecting Authsettings for CIS Benchmark"

  permissions {
    actions     = local.agentless_aks_connection_permissions_actions
    not_actions = []
  }

  assignable_scopes = [
    each.key,
  ]
}

#---------------------------------------------------------------------------------------------
# custom role assignment for collecting authsettings
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_cspm_role_assignment_for_tenant" {
  for_each = var.is_organizational ? local.scopes_for_resources : []

  scope              = each.key
  role_definition_id = azurerm_role_definition.sysdig_cspm_role_aks_discovery_for_tenant[each.key].role_definition_resource_id
  principal_id       = var.sysdig_cspm_sp_object_id
}
