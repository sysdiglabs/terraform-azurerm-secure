locals {
  # logic for determining which scopes should get resources
  # rule 1: include mode (include_management_groups provided) - use management group scopes + explicit subscriptions
  # rule 2: exclude mode (exclude_management_groups provided) - use root management group scope
  # rule 3: default mode (no filters) - use root management group scope

  # determine which scopes to include for resource creation
  scopes_for_resources = var.is_organizational ? (length(var.include_management_groups) > 0 ? (
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