# Azure Event Hub Datasource Module

This Module creates the resources required to send Subscription-specific activity logs to Sysdig by directing those to a dedicated `Event Hub` which will be queried by the Sysdig backend to retrieve the data for log ingestion. These resources enable Threat Detection in the given single subscription, or Azure Tenant.

The following resources will be created in each instrumented account:
- `Diagnostic Settings` to enable producing activity logs at `Subscription` level
- An `Event Hub` and its namespace to receive the activity logs
- A `Resource Group` to contain the `Event Hub`
- The necessary `Service Principal` and `Rule` to enable the activity log publishing operation

This module will also deploy an Event Hub Component in Sysdig Backend for onboarded Sysdig Cloud Account.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.45.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.76.0 |
| <a name="requirement_sysdig"></a> [sysdig](#requirement\_sysdig) | >= 1.28.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >= 2.45.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.76.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_sysdig"></a> [sysdig](#provider\_sysdig) | >= 1.28.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_service_principal.sysdig_event_hub_sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_eventhub.sysdig_event_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub) | resource |
| [azurerm_eventhub_consumer_group.sysdig_consumer_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_consumer_group) | resource |
| [azurerm_eventhub_namespace.sysdig_event_hub_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) | resource |
| [azurerm_eventhub_namespace_authorization_rule.sysdig_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace_authorization_rule) | resource |
| [azurerm_monitor_aad_diagnostic_setting.sysdig_entra_diagnostic_setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_aad_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.sysdig_diagnostic_setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.sysdig_org_diagnostic_setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_resource_group.sysdig_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.sysdig_data_receiver](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [sysdig_secure_cloud_auth_account_component.azure_event_hub](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/resources/secure_cloud_auth_account_component) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_management_group.onboarded_management_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |
| [azurerm_management_group.root_management_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |
| [azurerm_resource_group.existing](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.onboarded_subscriptions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_subscription.sysdig_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [sysdig_secure_trusted_azure_app.threat_detection](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/data-sources/secure_trusted_azure_app) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_inflate_enabled"></a> [auto\_inflate\_enabled](#input\_auto\_inflate\_enabled) | Whether or not auto-inflate is enabled for the Event Hub | `bool` | `true` | no |
| <a name="input_consumer_group_name"></a> [consumer\_group\_name](#input\_consumer\_group\_name) | Name of the consumer group to be created | `string` | `"sysdig-consumer-group"` | no |
| <a name="input_diagnostic_settings_name"></a> [diagnostic\_settings\_name](#input\_diagnostic\_settings\_name) | Name of the diagnostic settings to be created | `string` | `"sysdig-diagnostic-settings"` | no |
| <a name="input_enable_entra"></a> [enable\_entra](#input\_enable\_entra) | (Optional) Used to enable or disable Entra logs, defaults to true. | `bool` | `true` | no |
| <a name="input_entra_diagnostic_settings_name"></a> [entra\_diagnostic\_settings\_name](#input\_entra\_diagnostic\_settings\_name) | Name of the Entra diagnostic settings to be created | `string` | `"sysdig-entra-diagnostic-settings"` | no |
| <a name="input_event_hub_name"></a> [event\_hub\_name](#input\_event\_hub\_name) | Name of the Event Hub to be created | `string` | `"sysdig-event-hub"` | no |
| <a name="input_event_hub_namespace_name"></a> [event\_hub\_namespace\_name](#input\_event\_hub\_namespace\_name) | Name of the Event Hub Namespace to be created | `string` | `"sysdig-event-hub-namespace"` | no |
| <a name="input_eventhub_authorization_rule_name"></a> [eventhub\_authorization\_rule\_name](#input\_eventhub\_authorization\_rule\_name) | Name of the authorization rule to be created | `string` | `"sysdig-send-listen-rule"` | no |
| <a name="input_is_organizational"></a> [is\_organizational](#input\_is\_organizational) | (Optional) Set this field to 'true' to deploy secure-for-cloud to an Azure Tenant. | `bool` | `false` | no |
| <a name="input_management_group_ids"></a> [management\_group\_ids](#input\_management\_group\_ids) | (Optional) List of Azure Management Group IDs. secure-for-cloud will be deployed to all the subscriptions under these management groups. | `set(string)` | `[]` | no |
| <a name="input_maximum_throughput_units"></a> [maximum\_throughput\_units](#input\_maximum\_throughput\_units) | The maximum number of throughput units to be allocated to the Event Hub | `number` | `20` | no |
| <a name="input_message_retention_days"></a> [message\_retention\_days](#input\_message\_retention\_days) | Number of days during which messages will be retained in the Event Hub | `number` | `1` | no |
| <a name="input_namespace_sku"></a> [namespace\_sku](#input\_namespace\_sku) | SKU (Plan) for the namespace that will be created | `string` | `"Standard"` | no |
| <a name="input_partition_count"></a> [partition\_count](#input\_partition\_count) | The number of partitions in the Event Hub | `number` | `4` | no |
| <a name="input_region"></a> [region](#input\_region) | Datacenter where Sysdig-related resources will be created | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Name of the existing resource group | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group to be created | `string` | `"sysdig-resource-group"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Identifier of the subscription to be onboarded | `string` | n/a | yes |
| <a name="input_sysdig_secure_account_id"></a> [sysdig\_secure\_account\_id](#input\_sysdig\_secure\_account\_id) | ID of the Sysdig Cloud Account to enable Event Hub integration for (incase of organization, ID of the Sysdig management account) | `string` | n/a | yes |
| <a name="input_throughput_units"></a> [throughput\_units](#input\_throughput\_units) | The number of throughput units to be allocated to the Event Hub | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_event_hub_component_id"></a> [event\_hub\_component\_id](#output\_event\_hub\_component\_id) | Component identifier of Event Hub integration created in Sysdig Backend for Log Ingestion |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.
