# Azure VM Workload Scanning Module

This module will deploy VM Workload Scanning resources in Azure for a single subscription, or for an Azure Tenant.
The resources serve the following functions:
- pulling docker images from ACR for single subscription, or for all subscriptions within Azure Tenant.
- reading AppSettings for single subscription, or for all subscriptions within Azure Tenant.
- list azure functions for a single subscription, or for all subscriptions within Azure Tenant.
- storage file data reader for a single subscription, or for all subscriptions within Azure Tenant.
- storage blob data reader for a single subscription, or for all subscriptions within Azure Tenant.
- access to Kudu API for a single subscription, or for all subscriptions within Azure Tenant.

All of the above permissions will ensure the following actions are possible when authenticating as the VMWorkloadScanning Azure Service Principal:
- Pull docker images from ACR
- List Azure Functions
- Understand where Azure Functions code is located
- Read the code content of Azure Functions

All of these permissions are everything that is currently required to enabled VM Agentless Workload Scanning.

If instrumenting an Azure subscription, the following resources will be created:
- A Service Principal in your tenant, associated with the application ID of the VM Workload Scanning service client / app registration in the Sysdig tenant.
- Role assignments with minimal set of permissions for Azure subscription.
- A component creation in Sysdig Backend associated with the cloudAuth created during foundational onboarding

If instrumenting an Azure Tenant, the following resources will be created:
- A Service Principal in your tenant, associated with the application ID of the VM Workload Scanning service client / app registration in the Sysdig tenant.
- Role assignments with minimal set of permissions for Azure subscription provided as management account/subscription.
- Role assignments with minimal set of permissions at the Root Management Group level by default for the Tenant, or at each of the
instrumented Management Groups within the Tenant if provided, for retrieving inventory.
- A component creation in Sysdig Backend associated with the cloudAuth created during foundational onboarding

**Important**. If using a pre-existing Service Principal is needed, creating a service principal associated with the Sysdig VM Workload Scanning Application ID is required:
- The Sysdig VM Workload Scanning Application ID can be found as part of the output of the `sysdig_secure_trusted_azure_app` data source created in this module. Also, it can be retrieved by hitting the Sysdig onboarding API using the `sysdig_secure_api_token` provided within the Sysdig UI > Settings > Sysdig Secure API Token, the API curl command uses the `app=vm_workload_scanning` query parameter:
    ```bash
    curl --location 'https://<sysdig-secure>/api/secure/onboarding/v2/trustedAzureApp?app=vm_workload_scanning' \
    --header 'Authorization: Bearer <token>'
    ```
- From the previous call, use the `applicationId` field from the response to create the Service Principal in your Azure Tenant.
- Provide the Service Principal ID as input to the `vm_workload_scanning_service_principal` variable in this module. This will
  skip the creation of a new Service Principal and use the one provided instead.
- Contact Sysdig Support if you need assistance with this process.

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
| [azuread_service_principal.sysdig_vm_workload_scanning_sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_role_definition.storage_file_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_definition.storage_blob_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_definition.sysdig_vm_workload_scanning_func_app_config_role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_assignment.sysdig_vm_workload_scanning_func_app_config_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sysdig_vm_workload_scanning_file_reader_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sysdig_vm_workload_scanning_blob_reader_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sysdig_vm_workload_scanning_acrpull_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.sysdig_vm_workload_scanning_func_app_config_role_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_definition.sysdig_vm_workload_scanning_func_app_config_role_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_assignment.sysdig_vm_workload_scanning_acrpull_for_tenant_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sysdig_vm_workload_scanning_func_app_config_role_assignment_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sysdig_vm_workload_scanning_file_reader_role_assignment_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sysdig_vm_workload_scanning_blob_reader_role_assignment_for_tenant](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [sysdig_secure_cloud_auth_account_component.azure_workload_scanning_component](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/resources/secure_cloud_auth_account_component) | resource |

## Inputs

| Name                                                                                                                                                         | Description                                                                                                                                                                                                                                                                                          | Type          | Default | Required |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|---------|:--------:|
| <a name="input_sysdig_secure_account_id"></a> [sysdig\_secure\_account\_id](#input\_sysdig\_secure\_account\_id)                                             | ID of the Sysdig Cloud Account to enable VM Workload Scanning with optional AKS discovery                                                                                                                                                                                                            | `string`      | n/a     |   yes    |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)                                                                            | The identifier of the Azure Subscription in which to create secure-for-cloud vm workload scanning resources                                                                                                                                                                                          | `string`      | n/a     |   yes    |
| <a name="input_is_organizational"></a> [is\_organizational](#input\_is\_organizational)                                                                      | true/false whether vm workload scanning resources should be deployed in an organizational setup (all subscriptions of tenant) or not (only on default azure provider subscription)                                                                                                                   | `bool`        | `false` |    no    |
| <a name="aks_enabled"></a> [aks\_enabled](#output\_service\_principal\_component\_id)                                                                        | Set this field to 'true' to grant AKS discovery permissions to the secure-posture service principal                                                                                                                                                                                                  | `bool`        | false   |    no    |
| <a name="functions_enabled"></a> [functions\_enabled](#output\_service\_principal\_component\_id)                                                            | Set this field to 'true' to grant Functions Storage permissions to the secure-vm-workload-scanning service principal                                                                                                                                                                                 | `bool`        | false   |    no    |
| <a name="sysdig_cspm_sp_object_id"></a> [sysdig\_cspm\_sp\_object\_id](#output\_service\_principal\_component\_id)                                           | Object ID of the CSPM SP within the client's infra                                                                                                                                                                                                                                                   | `string`      | n/a     |   yes    |
| <a name="input_vm_workload_scanning_service_principal"></a> [vm\_workload_\scanning\_service\_principal](#input\_vm\_workload_\scanning\_service\_principal) | (Optional) Service Principal to be used for VM Workload Scanning, this SP needs to be associated to the Sysdig VM Workload Scanning Application ID. If not provided, a new one will be created.                                                                                                      | `string`      | `""`    |    no    |
| <a name="input_include_management_groups"></a> [suffix](#input\_include\_management_groups)                                                                  | management_groups to include for organization in the format '<management_group_idt>' i.e: management_group_id_1                                                                                                                                                                                      | `set(string)` | `[]`    |    no    |
| <a name="input_exclude_management_groups"></a> [suffix](#input\_exclude\_management_groups)                                                                  | management_groups to exclude for organization in the format '<management_group_idt>' i.e: management_group_id_1                                                                                                                                                                                      | `set(string)` | `[]`    |    no    |
| <a name="input_include_subscriptions"></a> [suffix](#input\_include\_subscriptions)                                                                          | subscriptions to include for organization. i.e: 12345678-1234-1234-1234-123456789abc                                                                                                                                                                                                                 | `set(string)` | `[]`    |    no    |
| <a name="input_exclude_subscriptions"></a> [suffix](#input\_exclude\_subscriptions)                                                                          | subscriptions to exclude for organization. i.e: 12345678-1234-1234-1234-123456789abc                                                                                                                                                                                                                 | `set(string)` | `[]`    |    no    |



## Outputs

| Name | Description                                                                              |
|------|------------------------------------------------------------------------------------------|
| <a name="output_service_principal_component_id"></a> [service\_principal\_component\_id](#output\_service\_principal\_component\_id) | Component identifier of the Component created in Sysdig Backend for VM Workload Scanning |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.
