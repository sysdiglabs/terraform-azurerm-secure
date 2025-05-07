# Azure Config Posture Module

This module will deploy resources in Azure for Config Posture (CSPM), for a single subscription, or for an Azure Tenant.

If instrumenting an Azure subscription, the following resources will be created:
- A Service Principal in your tenant, associated with the application ID of the Config Posture service client in the Sysdig tenant.
- Role assignments with associated role permissions to grant Sysdig read only permissions to secure your Azure subscription.

If instrumenting an Azure Tenant, the following resources will be created:
- A Service Principal in your tenant, associated with the application ID of the Config Posture service client in the Sysdig tenant.
- Role assignments with associated role permissions for Azure subscription provided as management account/subscription.
- Role assignments with associated role permissions at the Root Management Group level by default for the Tenant, or at each of the
instrumented Management Groups within the Tenant if provided.

**Important**. If using a pre-existing Service Principal is needed, creating a service principal associated with the Sysdig Config Posture Application ID is required:
- The Sysdig Config Posture Application ID can be found as part of the output of the `sysdig_secure_trusted_azure_app` data source created in this module. Also, it can be retrieved by hitting the Sysdig onboarding API using the `sysdig_secure_api_token` provided within the Sysdig UI > Settings > Sysdig Secure API Token, the API curl command uses the `app=config_posture` query parameter:
    ```bash
    curl --location 'https://<sysdig-secure>/api/secure/onboarding/v2/trustedAzureApp?app=config_posture' \
    --header 'Authorization: Bearer <token>'
    ```
- From the previous call, use the `applicationId` field from the response to create the Service Principal in your Azure Tenant.
- Assign the [Directory Reader role](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/permissions-reference#directory-readers) to the Service Principal created in your Azure Tenant. This is a required permission, the role template ID for this role is `88d8e3e3-8f55-4a1e-953a-9b9898b8876b`.
- Provide the Service Principal ID as input to the `config_posture_service_principal` variable in this module. This will
  skip the creation of a new Service Principal and use the one provided instead.
- Contact Sysdig Support if you need assistance with this process.

This module will also deploy a Service Principal Component in Sysdig Backend for onboarded Sysdig Cloud Account.

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
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >= 2.43.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.76.0 |
| <a name="provider_sysdig"></a> [sysdig](#provider\_sysdig) | >= 1.28.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_directory_role_assignment.sysdig_ad_reader](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/directory_role_assignment) | resource |
| [azuread_service_principal.sysdig_cspm_sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_role_assignment.sysdig_cspm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sysdig_cspm_role_assignment_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sysdig_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sysdig_reader_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.sysdig_cspm_role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_definition.sysdig_cspm_role_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [sysdig_secure_cloud_auth_account_component.azure_service_principal](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/resources/secure_cloud_auth_account_component) | resource |
| [azurerm_management_group.root_management_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [sysdig_secure_trusted_azure_app.config_posture](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/data-sources/secure_trusted_azure_app) | data source |

## Inputs

| Name                                                                                                                                     | Description                                                                                                                                                               | Type          | Default | Required |
|------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|---------|:--------:|
| <a name="input_agentless_aks_connection_enabled"></a> [agentless\_aks\_connection\_enabled](#input\_agentless\_aks\_connection\_enabled) | Enable the Agentless AKS connection to the K8s clusters within the cloud. This allows admin access. Read more about why this is needed in the official docs.              | `bool`        | `false` |    no    |
| <a name="input_is_organizational"></a> [is\_organizational](#input\_is\_organizational)                                                  | (Optional) Set this field to 'true' to deploy secure-for-cloud to an Azure Tenant.                                                                                        | `bool`        | `false` |    no    |
| <a name="input_management_group_ids"></a> [management\_group\_ids](#input\_management\_group\_ids)                                       | (Optional) List of Azure Management Group IDs. secure-for-cloud will be deployed to all the subscriptions under these management groups.                                  | `set(string)` | `[]`    |    no    |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)                                                        | Subscription ID in which to create resources for secure-for-cloud                                                                                                         | `string`      | n/a     |   yes    |
| <a name="input_sysdig_secure_account_id"></a> [sysdig\_secure\_account\_id](#input\_sysdig\_secure\_account\_id)                         | ID of the Sysdig Cloud Account to enable Config Posture for (incase of organization, ID of the Sysdig management account)                                                 | `string`      | n/a     |   yes    |
| <a name="input_config_posture_service_principal"></a> [config\_posture\_service\_principal](#input\_config\_posture\_service\_principal) | (Optional) Service Principal to be used for CSPM, this SP needs to be associated to the Sysdig Config Posture Application ID. If not provided, a new one will be created. | `string`      | `""`    |    no    |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_principal_component_id"></a> [service\_principal\_component\_id](#output\_service\_principal\_component\_id) | Component identifier of Service Principal created in Sysdig Backend for Config Posture |
| <a name="sysdig_cspm_sp_object_id"></a> [service\_principal\_component\_id](#output\_service\_principal\_component\_id) | Object ID of the CSPM SP within the client's infra |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.
