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

  # legacy mode: use management_group_ids if provided
  selected_management_group = var.is_organizational && local.check_old_management_group_ids_param ? (length(data.azurerm_management_group.onboarded_management_group) > 0 ? values(data.azurerm_management_group.onboarded_management_group) : [data.azurerm_management_group.root_management_group[0]]) : []

  # legacy mode: get all subscriptions from selected management groups
  legacy_all_mg_subscription_ids = flatten([
    for mg in local.selected_management_group : mg.all_subscription_ids
  ])

  # unified recursive mode: get subscriptions from granular-subscriptions modules when include_management_groups or exclude_management_groups is provided
  discovered_subscription_ids = var.is_organizational && !local.check_old_management_group_ids_param && (length(var.include_management_groups) > 0 || length(var.exclude_management_groups) > 0) ? (
    flatten([
      module.level0[0].subscriptions,
      module.level1[0].subscriptions,
      module.level2[0].subscriptions,
      module.level3[0].subscriptions,
      module.level4[0].subscriptions,
      module.level5[0].subscriptions,
      module.level6[0].subscriptions
    ])
  ) : []

  # include specific subscriptions that are not already discovered
  additional_subscription_ids = var.is_organizational && !local.check_old_management_group_ids_param && length(var.include_subscriptions) > 0 ? (
    [for s in var.include_subscriptions : s if !(contains(local.discovered_subscription_ids, s))]
  ) : []

  # combine discovered and additional subscriptions
  new_all_subscription_ids = concat(local.discovered_subscription_ids, local.additional_subscription_ids)

  # default mode: use root management group subscriptions when no include/exclude filters are provided
  default_all_mg_subscription_ids = var.is_organizational && !local.check_old_management_group_ids_param && length(var.include_management_groups) == 0 && length(var.exclude_management_groups) == 0 ? (
    length(var.exclude_subscriptions) > 0 ? (
      [for s in data.azurerm_management_group.root_management_group[0].all_subscription_ids : s if !(contains(var.exclude_subscriptions, s))]
      ) : (
      data.azurerm_management_group.root_management_group[0].all_subscription_ids
    )
  ) : []

  # combine all subscription ids based on mode
  all_mg_subscription_ids = concat(
    local.legacy_all_mg_subscription_ids,
    local.new_all_subscription_ids,
    local.default_all_mg_subscription_ids
  )
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