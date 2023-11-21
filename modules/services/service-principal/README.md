# Azure Service Prinicpal Module

This module will deploy a Service Principal in Azure for a single subscription, or for an Azure Tenant.

The following resources will be created:
- A Service Principal in your tenant, associated with the application ID of the service client in the Sysdig tenant.
- Role assignments with associated role permissions to grant Sysdig read only permissions to secure your Azure subscription, or Azure Tenant.

If instrumenting an Azure Tenant, the role assignments will be created at the Root Management Group level by default for the Tenant.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.76.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.43.0 |
| <a name="requirement_sysdig"></a> [sysdig](#requirement\_sysdig) | >= 1.18.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.76.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_service_principal.sysdig_sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_role_assignment.sysdig_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sysdig_k8s_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sysdig_vm_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sysdig_reader_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sysdig_k8s_reader_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sysdig_vm_user_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_management_group.sysdig_management_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The identifier of the Azure Subscription in which to create a trust relationship | `string` | n/a | yes |
| <a name="input_sysdig_client_id"></a> [sysdig\_client\_id](#input\_sysdig\_client\_id) | The application ID of the service client in the Sysdig tenant. Service principal will be created for this application client ID | `string` | n/a | yes |
| <a name="input_is_organizational"></a> [is\_organizational](#input\_is\_organizational) | true/false whether secure-for-cloud should be deployed in an organizational setup (all subscriptions of tenant) or not (only on default azure provider subscription) | `bool` | `false` | no |
| <a name="input_management_group"></a> [management\_group](#input\_management\_group) | Display name of the Azure Management Group. secure-for-cloud will be deployed to all subscriptions under this management group | `string` | `"Tenant Root Group"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_principal_display_name"></a> [service\_principal\_display\_name](#output\_service\_principal\_display\_name) | Display name of the Service Principal created |
| <a name="output_service_principal_client_id"></a> [service\_principal\_client\_id](#output\_service\_principal\_client\_id) | Client ID of the Service Principal created |
| <a name="output_service_principal_id"></a> [service\_principal\_id](#output\_service\_principal\_id) | Service Principal ID on the customer tenant |
| <a name="output_service_principal_app_display_name"></a> [service\_principal\_app\_display\_name](#output\_service\_principal\_app\_display\_name) | Display name of the Application created |
| <a name="output_service_principal_app_owner_organization_id"></a> [service\_principal\_app\_owner\_organization\_id](#output\_service\_principal\_app\_owner\_organization\_id) | Organization ID of the Application created |
| <a name="output_subscription_tenant_id"></a> [subscription\_tenant\_id](#output\_subscription\_tenant\_id) | Tenant ID of the Subscription |
| <a name="output_subscription_alias"></a> [subscription\_alias](#output\_subscription\_alias) | Display name of the subscription |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.
