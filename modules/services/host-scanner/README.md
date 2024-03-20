# Azure Agentless Host Scan Module

This module will deploy a LightHouse Definition and Assignment in Azure for a single subscription, , or for an Azure Tenant.

If instrumenting an Azure subscription, the following resources will be created:
- LightHouse Definition associated with Sysdig Service Principal and the VM Scanner Operator role.
- LightHouse Assignment associated with the LightHouse Definition and the Azure subscription provided.

If instrumenting an Azure Tenant, the following resources will be created:
- LightHouse Definition associated with Sysdig Service Principal and the VM Scanner Operator role.
- LightHouse Assignment associated with the LightHouse Definition and the Azure subscriptions under each of the
  instrumented Management Groups within the Tenant provided, if no Management Groups are provided, all subscriptions under Root Management Group level.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version   |
|------|-----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.76.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.43.0 |
| <a name="requirement_sysdig"></a> [sysdig](#requirement\_sysdig) | >= 1.19.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.76.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_lighthouse_definition.lighthouse_definition](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lighthouse_definition) | resource |
| [azurerm_lighthouse_assignment.lighthouse_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lighthouse_assignment) | resource |
| [azurerm_lighthouse_assignment.lighthouse_assignment_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lighthouse_assignment) | resource |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_management_group.root_management_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |
| [azurerm_management_group.management_groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |

## Inputs

| Name                                                                                                                      | Description                                                                                                                                                          | Type          | Default | Required |
|---------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|---------|:--------:|
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)                                         | The identifier of the Azure Subscription in which to create a trust relationship.                                                                                    | `string`      | n/a     |   yes    |
| <a name="input_sysdig_tenant_id"></a> [sysdig\_tenant\_id](#input\_sysdig\_tenant\_id)                                    | The identifier of Sysdig Tenant where the Sysdig Service Principal is set.                                                                                           | `string`      | n/a     |   yes    |
| <a name="input_sysdig_service_principal_id"></a> [sysdig\_service\_principal\_id](#input\_sysdig\_service\_principal\_id) | The identifier of the Sysdig Service Principal in the Sysdig tenant. A Lighthouse Definition linked to this Service Principal will be created.                       | `string`      | n/a     |   yes    |
| <a name="input_is_organizational"></a> [is\_organizational](#input\_is\_organizational)                                   | true/false whether secure-for-cloud should be deployed in an organizational setup (all subscriptions of tenant) or not (only on default azure provider subscription) | `bool`        | `false` |    no    |
| <a name="input_management_group_ids"></a> [management\_group\_ids](#input\_management\_group\_ids)                        | List of Azure Management Group IDs. secure-for-cloud will be deployed to all the subscriptions under these management groups.                                        | `set(string)` | `[]`    |    no    |

## Outputs

| Name                                                                                                                              | Description                                                                            |
|-----------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------|
| <a name="lighthouse_definition_display_id"></a> [lighthouse\_definition\_display\id](#output\_lighthouse\_definition\_display\id) | Display id of the Lighthouse Definition created, associated with the Service Principal |
| <a name="output_subscription_alias"></a> [subscription\_alias](#output\_subscription\_alias)                                      | Display name of the subscription                                                       |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.
