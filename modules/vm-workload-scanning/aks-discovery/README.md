# Azure AKS Discovery Submodule

This module create a custom role definition with full Kubernetes management permissions and assign it to the service principal created within the client's infrastructure for secure-posture.

These permissions are required in order to enable CSPM to fully discover AKS clusters within Azure.

If instrumenting an Azure subscription, the following resources will be created:
- A custom role for full kubernetes cluster management
- A role assignment for the above role against secure-posture Service principal created during foundational onboarding

If instrumenting an Azure Tenant, the following resources will be created:
- Role definitions for full kubernetes cluster management for each management group selected
- Role assignments for the above roles against secure-posture Service principal created during foundational onboarding

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version   |
|------|-----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.76.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.43.0 |
| <a name="requirement_sysdig"></a> [sysdig](#requirement\_sysdig) | >= 1.29.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.76.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_role_definition.sysdig_cspm_aks_discovery_role](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_role_assignment.sysdig_cspm_role_aks_discovery_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_definition.sysdig_cspm_role_aks_discovery_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_assignment.sysdig_cspm_role_assignment_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |

## Inputs

| Name                                                                                                             | Description                                                                                                                                                                                                                                                                                          | Type          | Default | Required |
|------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|---------|:--------:|
| <a name="input_sysdig_secure_account_id"></a> [sysdig\_secure\_account\_id](#input\_sysdig\_secure\_account\_id) | ID of the Sysdig Cloud Account to enable Config Posture for (incase of organization, ID of the Sysdig management account)                                                                                                                                                                            | `string`      | n/a     |   yes    |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)                                | Subscription ID in which to create secure-for-cloud onboarding resources                                                                                                                                                                                                                             | `string`      | n/a     |   yes    |
| <a name="input_is_organizational"></a> [is\_organizational](#input\_is\_organizational)                          | (Optional) Set this field to 'true' to deploy secure-for-cloud to an Azure Tenant                                                                                                                                                                                                                    | `bool`        | `false` |    no    |
| <a name="input_management_group_ids"></a> [suffix](#input\_management\_group\_ids)                               | TO BE DEPRECATED on 30th November, 2025: Please work with Sysdig to migrate to using `include_management_groups` instead.<br> List of Azure Management Group IDs. secure-for-cloud will be deployed to all the subscriptions under these management groups. If not provided, set to empty by default | `set(string)` | `[]`    |    no    |
| <a name="sysdig_cspm_sp_object_id"></a> [sysdig\_cspm\_sp\_object\_id](#input\_sysdig\_cspm\_sp\_object\_id)     | Object ID of the CSPM SP within the client's infra                                                                                                                                                                                                                                                   | `string`      | n/a     |   yes    |
| <a name="input_include_management_groups"></a> [suffix](#input\_include\_management_groups)                      | management_groups to include for organization in the format '<management_group_idt>' i.e: management_group_id_1                                                                                                                                                                                      | `set(string)` | `[]`    |    no    |
| <a name="input_exclude_management_groups"></a> [suffix](#input\_exclude\_management_groups)                      | management_groups to exclude for organization in the format '<management_group_idt>' i.e: management_group_id_1                                                                                                                                                                                      | `set(string)` | `[]`    |    no    |
| <a name="input_include_subscriptions"></a> [suffix](#input\_include\_subscriptions)                              | subscriptions to include for organization. i.e: 12345678-1234-1234-1234-123456789abc                                                                                                                                                                                                                 | `set(string)` | `[]`    |    no    |
| <a name="input_exclude_subscriptions"></a> [suffix](#input\_exclude\_subscriptions)                              | subscriptions to exclude for organization. i.e: 12345678-1234-1234-1234-123456789abc                                                                                                                                                                                                                 | `set(string)` | `[]`    |    no    |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.
