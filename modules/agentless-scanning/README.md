# Azure Agentless Host Scanning Module

This module is used for Volume Access integration in Azure. The module will deploy a
LightHouse Definition and Assignment in Azure for a single subscription, , or for an Azure Tenant.
These resources enable Agentless Scanning in the given single subscription, or Azure Tenant.

If instrumenting an Azure subscription, the following resources will be created:
- LightHouse Definition associated with Sysdig Service Principal and the VM Scanner Operator role.
- LightHouse Assignment associated with the LightHouse Definition and the Azure subscription provided.

If instrumenting an Azure Tenant, the following resources will be created:
- LightHouse Definition associated with Sysdig Service Principal and the VM Scanner Operator role.
- LightHouse Assignment associated with the LightHouse Definition and the Azure subscriptions under each of the
  instrumented Management Groups within the Tenant provided, if no Management Groups are provided, all subscriptions under Root Management Group level.

This module will also deploy a Service Principal Component in Sysdig Backend for onboarded Sysdig Cloud Account for creating the Agentless Host scanning feature.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.43.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.76.0 |
| <a name="requirement_sysdig"></a> [sysdig](#requirement\_sysdig) | >= 1.28.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.76.0 |
| <a name="provider_sysdig"></a> [sysdig](#provider\_sysdig) | >= 1.28.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_lighthouse_assignment.lighthouse_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lighthouse_assignment) | resource |
| [azurerm_lighthouse_assignment.lighthouse_assignment_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lighthouse_assignment) | resource |
| [azurerm_lighthouse_definition.lighthouse_definition](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lighthouse_definition) | resource |
| [sysdig_secure_cloud_auth_account_component.azure_service_principal](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/resources/secure_cloud_auth_account_component) | resource |
| [azurerm_management_group.management_groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |
| [azurerm_management_group.root_management_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [sysdig_secure_agentless_scanning_assets.assets](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/data-sources/secure_agentless_scanning_assets) | data source |

## Inputs

| Name                                                                                                             | Description                                                                                                                                                                                                                                                                                          | Type          | Default | Required |
|------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|---------|:--------:|
| <a name="input_is_organizational"></a> [is\_organizational](#input\_is\_organizational)                          | (Optional) Set this field to 'true' to deploy secure-for-cloud to an Azure Tenant.                                                                                                                                                                                                                   | `bool`        | `false` |    no    |
| <a name="input_management_group_ids"></a> [suffix](#input\_management\_group\_ids)                               | TO BE DEPRECATED on 30th November, 2025: Please work with Sysdig to migrate to using `include_management_groups` instead.<br> List of Azure Management Group IDs. secure-for-cloud will be deployed to all the subscriptions under these management groups. If not provided, set to empty by default | `set(string)` | `[]`    |    no    |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)                                | Subscription ID in which to create a trust relationship                                                                                                                                                                                                                                              | `string`      | n/a     |   yes    |
| <a name="input_sysdig_secure_account_id"></a> [sysdig\_secure\_account\_id](#input\_sysdig\_secure\_account\_id) | ID of the Sysdig Cloud Account to enable Agentless Scanning for (incase of organization, ID of the Sysdig management account)                                                                                                                                                                        | `string`      | n/a     |   yes    |
| <a name="input_include_management_groups"></a> [suffix](#input\_include\_management_groups)                      | management_groups to include for organization in the format '<management_group_idt>' i.e: management_group_id_1                                                                                                                                                                                      | `set(string)` | `[]`    |    no    |
| <a name="input_exclude_management_groups"></a> [suffix](#input\_exclude\_management_groups)                      | management_groups to exclude for organization in the format '<management_group_idt>' i.e: management_group_id_1                                                                                                                                                                                      | `set(string)` | `[]`    |    no    |
| <a name="input_include_subscriptions"></a> [suffix](#input\_include\_subscriptions)                              | subscriptions to include for organization. i.e: 12345678-1234-1234-1234-123456789abc                                                                                                                                                                                                                 | `set(string)` | `[]`    |    no    |
| <a name="input_exclude_subscriptions"></a> [suffix](#input\_exclude\_subscriptions)                              | subscriptions to exclude for organization. i.e: 12345678-1234-1234-1234-123456789abc                                                                                                                                                                                                                 | `set(string)` | `[]`    |    no    |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lighthouse_definition_display_id"></a> [lighthouse\_definition\_display\_id](#output\_lighthouse\_definition\_display\_id) | Display id of the Light House definition created |
| <a name="output_service_principal_component_id"></a> [service\_principal\_component\_id](#output\_service\_principal\_component\_id) | Component identifier of Service Principal created in Sysdig Backend for Agentless Scanning |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.
