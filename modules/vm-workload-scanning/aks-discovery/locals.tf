locals {
  # check if both old and new include/exclude org parameters are used, we fail early
  both_org_configuration_params = var.is_organizational && length(var.management_group_ids) > 0 && (
  length(var.include_management_groups) > 0 ||
  length(var.exclude_management_groups) > 0 ||
  length(var.include_subscriptions) > 0 ||
  length(var.exclude_subscriptions) > 0
  )

  # check if old management_group_ids parameter is provided, for backwards compatibility we will always give preference to it
  check_old_management_group_ids_param = var.is_organizational && length(var.management_group_ids) > 0

  # logic for determining which scopes should get resources
  # rule 1: legacy mode (management_group_ids provided) - use management group scopes
  # rule 2: include mode (include_management_groups provided) - use management group scopes + explicit subscriptions
  # rule 3: exclude mode (exclude_management_groups provided) - use root management group scope
  # rule 4: default mode (no filters) - use root management group scope
  
  # determine which scopes to include for resource creation
  scopes_for_resources = var.is_organizational ? (local.check_old_management_group_ids_param ? (
    # legacy mode: use management_group_ids if provided
    toset([for m in var.management_group_ids : format("%s/%s", "/providers/Microsoft.Management/managementGroups", m)])
  ) : length(var.include_management_groups) > 0 ? (
    # include mode: use specified management groups + explicitly included subscriptions
    toset(concat(
      [for m in var.include_management_groups : format("%s/%s", "/providers/Microsoft.Management/managementGroups", m)],
      [for s in var.include_subscriptions : "/subscriptions/${s}"]
    ))
  ) : (
    # exclude mode or default mode: use root management group scope (tenant level)
    toset([data.azurerm_management_group.root_management_group[0].id])
  )) : []
}

check "validate_org_configuration_params" {
  assert {
    condition     = length(var.management_group_ids) == 0 # if this condition is false we throw warning
    error_message = <<-EOT
    WARNING: 'management_group_ids' TO BE DEPRECATED on 30th November, 2025: Please work with Sysdig to migrate your Terraform installs to use 'include_management_groups' instead.
    EOT
  }

  assert {
    condition     = !local.both_org_configuration_params # if this condition is false we throw error
    error_message = <<-EOT
    ERROR: If both management_group_ids and include_management_groups/exclude_management_groups/include_subscriptions/exclude_subscriptions variables are populated,
    ONLY management_group_ids will be considered. Please use only one of the two methods.
    Note: management_group_ids is going to be DEPRECATED on 30th November, 2025. Please work with Sysdig to migrate your Terraform installs.
    EOT
  }
}