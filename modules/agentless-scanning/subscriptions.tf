# Azure supports up to 6 levels of management groups(do not include root management group), so we will create a module to get subscriptions using include/exclude filters for each level.
# This is a workaround for the fact that Azure does not support recursive management group queries in TF.
# http://learn.microsoft.com/en-us/azure/governance/management-groups/overview#important-facts-about-management-groups

# Rules for this module:
# 1. We will exercise the module if 'exclude_management_groups' is set. We will recursively get all the management groups from the root management group id and exclude the ones in the exclude_management_groups list.
# 2. We will exercise the module if 'include_management_groups' is set. We will recursively get all the management groups from the management group list and exclude the ones in the exclude_management_groups list.
# 3. We will honor the include/exclude logic for subscriptions as well.

module "level0" {
  count                     = var.is_organizational && (length(var.include_management_groups) > 0 || length(var.exclude_management_groups) > 0) ? 1 : 0
  source                    = "../utils/granular-subscriptions"
  management_group_ids      = length(var.include_management_groups) > 0 ? var.include_management_groups : [data.azurerm_management_group.root_management_group[0].name]
  exclude_management_groups = var.exclude_management_groups
  include_subscriptions     = var.include_subscriptions
  exclude_subscriptions     = var.exclude_subscriptions
}

module "level1" {
  count                     = var.is_organizational && (length(var.include_management_groups) > 0 || length(var.exclude_management_groups) > 0) ? 1 : 0
  source                    = "../utils/granular-subscriptions"
  management_group_ids      = module.level0[0].child_management_group_ids
  exclude_management_groups = var.exclude_management_groups
  include_subscriptions     = var.include_subscriptions
  exclude_subscriptions     = var.exclude_subscriptions
}

module "level2" {
  count                     = var.is_organizational && (length(var.include_management_groups) > 0 || length(var.exclude_management_groups) > 0) ? 1 : 0
  source                    = "../utils/granular-subscriptions"
  management_group_ids      = module.level1[0].child_management_group_ids
  exclude_management_groups = var.exclude_management_groups
  include_subscriptions     = var.include_subscriptions
  exclude_subscriptions     = var.exclude_subscriptions
}

module "level3" {
  count                     = var.is_organizational && (length(var.include_management_groups) > 0 || length(var.exclude_management_groups) > 0) ? 1 : 0
  source                    = "../utils/granular-subscriptions"
  management_group_ids      = module.level2[0].child_management_group_ids
  exclude_management_groups = var.exclude_management_groups
  include_subscriptions     = var.include_subscriptions
  exclude_subscriptions     = var.exclude_subscriptions
}

module "level4" {
  count                     = var.is_organizational && (length(var.include_management_groups) > 0 || length(var.exclude_management_groups) > 0) ? 1 : 0
  source                    = "../utils/granular-subscriptions"
  management_group_ids      = module.level3[0].child_management_group_ids
  exclude_management_groups = var.exclude_management_groups
  include_subscriptions     = var.include_subscriptions
  exclude_subscriptions     = var.exclude_subscriptions
}

module "level5" {
  count                     = var.is_organizational && (length(var.include_management_groups) > 0 || length(var.exclude_management_groups) > 0) ? 1 : 0
  source                    = "../utils/granular-subscriptions"
  management_group_ids      = module.level4[0].child_management_group_ids
  exclude_management_groups = var.exclude_management_groups
  include_subscriptions     = var.include_subscriptions
  exclude_subscriptions     = var.exclude_subscriptions
}

module "level6" {
  count                     = var.is_organizational && (length(var.include_management_groups) > 0 || length(var.exclude_management_groups) > 0) ? 1 : 0
  source                    = "../utils/granular-subscriptions"
  management_group_ids      = module.level5[0].child_management_group_ids
  exclude_management_groups = var.exclude_management_groups
  include_subscriptions     = var.include_subscriptions
  exclude_subscriptions     = var.exclude_subscriptions
} 