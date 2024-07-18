# Azure Onboarding Module

This module will deploy Foundational Onboarding resources in Azure for a single subscription, or for an Azure Tenant.
The Foundational Onboarding module serves the following functions:
- retrieving inventory for single subscription, or for all subscriptions within Azure Tenant.
- running organization scraping in the case of organizational onboarding within Azure Tenant.

If instrumenting an Azure subscription, the following resources will be created:
- A Service Principal in your tenant, associated with the application ID of the Onboarding service client / app registration in the Sysdig tenant.
- Role assignments with minimal set of permissions for Azure subscription, to grant Sysdig read only permissions for retrieving inventory.
- A cloud account in the Sysdig Backend, associated with the Azure subscription and with the required component to serve the foundational functions.

If instrumenting an Azure Tenant, the following resources will be created:
- A Service Principal in your tenant, associated with the application ID of the Onboarding service client / app registration in the Sysdig tenant.
- Role assignments with minimal set of permissions for Azure subscription provided as management account/subscription, for retrieving inventory
and running organization scraping.
- Role assignments with minimal set of permissions at the Root Management Group level by default for the Tenant, or at each of the
instrumented Management Groups within the Tenant if provided, for retrieving inventory.
- A cloud account in the Sysdig Backend, associated with the Azure subscription and with the required component to serve the foundational functions. 
- A cloud organization in the Sysdig Backend, associated with the Azure Tenant to fetch the organization structure to install Sysdig Secure for Cloud on.

Note:
- The outputs from the foundational module, such as `sysdig_secure_account_id` are needed as inputs to the other features/integrations modules for subsequent modular installs.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.76.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.43.0 |
| <a name="requirement_sysdig"></a> [sysdig](#requirement\_sysdig) | >= 1.28.5 |

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
| [sysdig_secure_trusted_azure_app.onboarding](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/data-sources/secure_trusted_azure_app) | data source |
| [azurerm_management_group.root_management_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The identifier of the Azure Subscription in which to create secure-for-cloud onboarding resources | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\tenant\_id) | The identifier of the Azure Active Directory Tenant of which the subscription is part of | `string` | n/a | yes |
| <a name="input_is_organizational"></a> [is\_organizational](#input\_is\_organizational) | true/false whether secure-for-cloud should be deployed in an organizational setup (all subscriptions of tenant) or not (only on default azure provider subscription) | `bool` | `false` | no |
| <a name="input_management_group_ids"></a> [management\_group\_ids](#input\_management\_group\_ids) | List of Azure Management Group IDs. secure-for-cloud will be deployed to all the subscriptions under these management groups. | `set(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | Subscription ID in which secure-for-cloud onboarding resources are created. For organizational installs it is the Management Subscription ID |
| <a name="output_sysdig_secure_account_id"></a> [sysdig\_secure\_account\_id](#output\_sysdig\_secure\_account\_id) | ID of the Sysdig Cloud Account created |
| <a name="output_is_organizational"></a> [is\_organizational](#output\_is\_organizational) | Boolean value to indicate if secure-for-cloud is deployed to an entire Azure Tenant or not |
| <a name="output_management_group_ids"></a> [management\_group\_ids](#output\_management\_group\_ids) | List of Azure Management Group IDs on which secure-for-cloud is deployed |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.
