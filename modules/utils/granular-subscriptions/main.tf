#---------------------------------------------------------------------------------------------
# Fetch management groups and discover their child management groups and subscriptions
#---------------------------------------------------------------------------------------------
# Get management group details for each provided management group ID
data "azurerm_management_group" "mg" {
  for_each = toset(var.management_group_ids)
  name     = each.value
}

locals {
  #---------------------------------------------------------------------------------------------
  # Filter management groups: exclude specified management groups from the discovery
  #---------------------------------------------------------------------------------------------
  # Create a list of valid management group names by filtering out excluded ones
  valid_mgs = [for k, mg in data.azurerm_management_group.mg : k if !(contains(var.exclude_management_groups, k))]

  #---------------------------------------------------------------------------------------------
  # Extract child management group IDs from valid management groups
  #---------------------------------------------------------------------------------------------
  # Flatten the list of child management group IDs from all valid management groups
  # Use regex to extract just the management group name from the full resource ID
  child_mgs = flatten([
    for k in local.valid_mgs :
    [
      for id in data.azurerm_management_group.mg[k].management_group_ids :
      regex("[^/]+$", id)
    ]
  ])

  #---------------------------------------------------------------------------------------------
  # Get all subscriptions from valid management groups
  #---------------------------------------------------------------------------------------------
  # Flatten the list of subscription IDs from all valid management groups
  all_subscriptions = flatten([
    for k in local.valid_mgs :
    data.azurerm_management_group.mg[k].subscription_ids
  ])

  #---------------------------------------------------------------------------------------------
  # Filter subscriptions: apply exclusion filters if exclude_subscriptions is provided
  #---------------------------------------------------------------------------------------------
  # If exclude_subscriptions is provided, filter out those subscriptions
  # Otherwise, return all discovered subscriptions
  subscriptions = length(var.exclude_subscriptions) > 0 ? (
    [for s in local.all_subscriptions : s if !(contains(var.exclude_subscriptions, s))]
    ) : (
    local.all_subscriptions
  )
}