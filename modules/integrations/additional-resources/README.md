# Azure Additional Resources Module

This module creates diagnostic settings for all the resources specified by the client and directs the logs for those specified resources to the existing Event Hub, which will be queried by the Sysdig backend for log ingestion.
The resources will forward only the logs specified by the user.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.76.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.76.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                               | Type |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------|
| [azurerm_monitor_diagnostic_setting.sysdig_custom_diagnostic_settings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |

## Inputs

| Name                                                                                                        | Description                                                                                                                              | Type     | Default | Required |
|-------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|----------|---------|:--------:|
| <a name="input_event_hub_name"></a> [event\_hub\_name](#input\_event\_hub\_name)                            | Event Hub integration created for Sysdig Log Ingestion | `string` | n/a	    |   yes    |
| <a name="input_sysdig_authorization_id"></a> [sysdig\_authorization\_id](#input\_sysdig\_authorization\_id) | Identifier of Authorization Rule for the Sysdig Namespace | `string`       | n/a	    |   yes    |
| <a name="input_deployment_identifier"></a> [deployment\_identifier](#input\_deployment\_identifier)         | Identifier of Deployment that gets added to provisioned resources | `string`       | n/a	    |   yes    |
| <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings)               | Map of resource IDs to the list of logs to enable | `map(list(string))`       | {}	     |   yes    |
## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.
