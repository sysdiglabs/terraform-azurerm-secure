locals {
  # unified recursive mode: get subscriptions from granular-subscriptions modules when include_management_groups or exclude_management_groups is provided
  discovered_subscription_ids = var.is_organizational && (length(var.include_management_groups) > 0 || length(var.exclude_management_groups) > 0) ? (
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
  additional_subscription_ids = var.is_organizational && length(var.include_subscriptions) > 0 ? (
    [for s in var.include_subscriptions : s if !(contains(local.discovered_subscription_ids, s))]
  ) : []

  # combine discovered and additional subscriptions
  new_all_subscription_ids = concat(local.discovered_subscription_ids, local.additional_subscription_ids)

  # default mode: use root management group subscriptions when no include/exclude filters are provided
  default_all_mg_subscription_ids = var.is_organizational && length(var.include_management_groups) == 0 && length(var.exclude_management_groups) == 0 ? (
    length(var.exclude_subscriptions) > 0 ? (
      [for s in data.azurerm_management_group.root_management_group[0].all_subscription_ids : s if !(contains(var.exclude_subscriptions, s))]
      ) : (
      data.azurerm_management_group.root_management_group[0].all_subscription_ids
    )
  ) : []

  # combine all subscription ids based on mode and add var.subscription_id if not already present
  all_mg_subscription_ids = distinct(concat(
    local.new_all_subscription_ids,
    local.default_all_mg_subscription_ids,
    [var.subscription_id]
  ))
}