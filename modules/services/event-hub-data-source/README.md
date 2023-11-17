# Azure Event Hub Datasource Module

This Module creates the resources required to send Subscription-specific activity logs to Sysdig by directing those to a dedicated `Event Hub` which will be queries by the Sysdig backend to retrieve the data. 

The following resources will be created in each instrumented account:
- `Diagnostic Settings` to enable producing activity logs at `Subscription` level
- An `Event Hub` and its namespace to receive the activity logs
- A `Resource Group` to contain the `Event Hub`
- The necessary `Service Principal` and `Rule` to enable the activity log publishing operation

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.76.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.45.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.80.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_service_principal.sysdig_service_principal](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_eventhub.sysdig_event_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub) | resource |
| [azurerm_eventhub_consumer_group.sysdig_consumer_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_consumer_group) | resource |
| [azurerm_eventhub_namespace.sysdig_event_hub_namespace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) | resource |
| [azurerm_eventhub_namespace_authorization_rule.sysdig_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace_authorization_rule) | resource |
| [azurerm_monitor_diagnostic_setting.sysdig_diagnostic_setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_resource_group.sysdig_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.sysdig_data_receiver](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_subscription.sysdig_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Location where Sysdig-related resources will be created | `string` | n/a | yes |
| <a name="input_message_retention_days"></a> [message\_retention\_days](#input\_message\_retention\_days) | Number of days during which messages will be retained in the Event Hub | `number` | `1` | no |
| <a name="input_namespace_sku"></a> [namespace\_sku](#input\_namespace\_sku) | SKU (Plan) for the namespace that will be created | `string` | `"Standard"` | no |
| <a name="input_partition_count"></a> [partition\_count](#input\_partition\_count) | The number of partitions in the Event Hub | `number` | `4` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Identifier of the subscription to be onboarded | `string` | n/a | yes |
| <a name="input_sysdig_client_id"></a> [sysdig\_client\_id](#input\_sysdig\_client\_id) | Application ID of the enterprise application in the Sysdig tenant | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Identifier of the Azure tenant | `string` | n/a | yes |

## Outputs

No outputs.

## Authors

Module is maintained by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.
