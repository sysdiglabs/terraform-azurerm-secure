# Azure Onboarding Module

This module will deploy an Onboarding Service Principal resource in Azure for a single subscription, or for an Azure Tenant.
The Onboarding module serves the following:
- retrieving inventory for single subscription, or for all subscriptions within Azure Tenant.
- running organization scraping in the case of organizational onboarding within Azure Tenant.

If instrumenting an Azure subscription, the following resources will be created:
- A Service Principal in your tenant, associated with the application ID of the Onboarding service client in the Sysdig tenant.
- Role assignments with minimal set of permissions for Azure subscription, to grant Sysdig read only permissions for retrieving inventory.

If instrumenting an Azure Tenant, the following resources will be created:
- A Service Principal in your tenant, associated with the application ID of the Onboarding service client in the Sysdig tenant.
- Role assignments with minimal set of permissions for Azure subscription provided as management account/subscription, for retrieving inventory
and running organization scraping.
- Role assignments with minimal set of permissions at the Root Management Group level by default for the Tenant, or at each of the
instrumented Management Groups within the Tenant if provided, for retrieving inventory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.76.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.43.0 |
| <a name="requirement_sysdig"></a> [sysdig](#requirement\_sysdig) | >= 1.24.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.76.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_service_principal.sysdig_onboarding_sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_role_assignment.sysdig_onboarding_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sysdig_onboarding_reader_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [sysdig_secure_cloud_auth_account.azure_account](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/resources/secure_cloud_auth_account) | resource |
| [sysdig_secure_organization.azure_organization](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/resources/secure_organization) | resource |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_management_group.root_management_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The identifier of the Azure Subscription in which to create secure-for-cloud onboarding resources | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\tenant\_id) | The identifier of the Azure Active Directory Tenant of which the subscription is part of | `string` | n/a | yes |
| <a name="input_sysdig_client_id"></a> [sysdig\_client\_id](#input\_sysdig\_client\_id) | The application ID of the Onboarding service client in the Sysdig tenant. Onboarding Service principal will be created for this application client ID in customer tenant | `string` | n/a | yes |
| <a name="input_is_organizational"></a> [is\_organizational](#input\_is\_organizational) | true/false whether secure-for-cloud should be deployed in an organizational setup (all subscriptions of tenant) or not (only on default azure provider subscription) | `bool` | `false` | no |
| <a name="input_management_group_ids"></a> [management\_group\_ids](#input\_management\_group\_ids) | List of Azure Management Group IDs. secure-for-cloud will be deployed to all the subscriptions under these management groups. | `set(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_principal_display_name"></a> [service\_principal\_display\_name](#output\_service\_principal\_display\_name) | Display name of the Onboarding Service Principal created |
| <a name="output_sysdig_secure_account_id"></a> [sysdig\_secure\_account\_id](#output\_sysdig\_secure\_account\_id) | ID of the Sysdig Cloud Account created |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.
