# Azure Agentless Host Scanning Module

This module is used for Enabling the Feature of Azure Container Instances / Container Apps integration in Azure. 
The module will deploy no resources to the clients infra and simply perform the api call against cloud auth to enable the feature,
as the basis CSPM permissions are already enough to perform all the actions necessary.

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
|------|-----|
| none | n/a |

## Inputs

| Name | Description                                                                                                                                                                                                         | Type | Default                      |                   Required                    |
|------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------|------------------------------|:---------------------------------------------:|
| <a name="input_is_organizational"></a> [is\_organizational](#input\_is\_organizational) | Set this field to 'true' to deploy agentless scanning of aca/aci to an Azure Tenant.                                                                                                                     | `bool` | `false`                      |                      no                       |
| <a name="input_management_group_ids"></a> [management\_group\_ids](#input\_management\_group\_ids) | List of Azure Management Group IDs. secure-for-cloud will be deployed to all the subscriptions under these management groups. If not sent the root management group will be used | `set(string)` | `[root_managament_group.id]` |                      no                       |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Subscription ID in which to enable the feature                                                                                                                                   | `string` | n/a                          | partially (mandatory for single subscription) |

## Outputs

| Name | Description                                                                                |
|------|--------------------------------------------------------------------------------------------|
| <a name="input_is_organizational"></a> [is\_organizational](#input\_is\_organizational) | Whether customer onboarded in organizational mode                                          |
| <a name="input_management_group_ids"></a> [management\_group\_ids](#input\_management\_group\_ids) | Managament group ids provided by the customer                                              |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Subscription id provided for single subscription onboarding                                |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.
