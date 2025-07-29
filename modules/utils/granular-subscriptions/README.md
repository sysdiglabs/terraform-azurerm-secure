# Granular Subscriptions Module

This module provides recursive discovery of Azure management groups and subscriptions with granular filtering capabilities. It is designed to work around Azure's limitation of not supporting recursive management group queries in Terraform.

The module supports up to 6 levels of management group hierarchy discovery and provides flexible include/exclude filtering for both management groups and subscriptions.

## Features

- **Recursive Discovery**: Traverses up to 6 levels of management group hierarchy
- **Granular Filtering**: Supports include/exclude filters for management groups and subscriptions
- **Flexible Configuration**: Can start discovery from specified management groups or root management group
- **Subscription Filtering**: Can include or exclude specific subscriptions from the discovered list

## Use Cases

This module is primarily used by other modules that need to:
- Discover all subscriptions under specific management groups
- Exclude certain management groups or subscriptions from discovery
- Handle complex Azure tenant hierarchies with nested management groups
- Provide granular control over which subscriptions receive resources

## How It Works

1. **Input Management Groups**: Takes a list of management group IDs to start discovery from
2. **Recursive Traversal**: Discovers child management groups at each level (up to 6 levels deep)
3. **Filtering**: Applies include/exclude filters for both management groups and subscriptions
4. **Output**: Returns filtered lists of management groups and subscriptions

## Important Notes

- Azure supports up to 6 levels of management groups (excluding root)
- The module uses regex to extract management group names from full resource IDs
- Subscription filtering only excludes subscriptions if `exclude_subscriptions` is provided
- If no `exclude_subscriptions` is provided, all discovered subscriptions are returned

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.76.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.76.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_management_group.mg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_management_group_ids"></a> [management\_group\_ids](#input\_management\_group\_ids) | List of management group names to include for organization in the format '<management_group_id>' i.e: management_group_id_1 | `list(string)` | n/a | yes |
| <a name="input_exclude_management_groups"></a> [exclude\_management\_groups](#input\_exclude\_management\_groups) | List of management group names to exclude for organization in the format '<management_group>' i.e: management_group_id_1 | `set(string)` | `[]` | no |
| <a name="input_include_subscriptions"></a> [include\_subscriptions](#input\_include\_subscriptions) | List of subscription ids to include for organization in the format '<subscription_id>' | `set(string)` | `[]` | no |
| <a name="input_exclude_subscriptions"></a> [exclude\_subscriptions](#input\_exclude\_subscriptions) | List of subscription ids to exclude for organization in the format '<subscription_id>' | `set(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_valid_mg_names_at_level"></a> [valid\_mg\_names\_at\_level](#output\_valid\_mg\_names\_at\_level) | List of valid management group names at the current level after applying exclude filters |
| <a name="output_child_management_group_ids"></a> [child\_management\_group\_ids](#output\_child\_management\_group\_ids) | List of child management group IDs discovered from the input management groups |
| <a name="output_subscriptions"></a> [subscriptions](#output\_subscriptions) | List of subscription IDs discovered from the valid management groups after applying subscription filters |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Sysdig](https://sysdig.com). 