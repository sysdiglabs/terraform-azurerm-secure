# Azure Event Hub Datasource Module

This module will deploy an Event Hub Component in Sysdig Backend for onboarded Sysdig Cloud Account.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_sysdig"></a> [sysdig](#requirement\_sysdig) | >= 1.24.2 |

## Providers

No providers.

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [sysdig_secure_cloud_auth_account_component.azure_event_hub](https://registry.terraform.io/providers/sysdiglabs/sysdig/latest/docs/resources/secure_cloud_auth_account_component) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_sysdig_secure_account_id"></a> [sysdig\_secure\_account\_id](#input\_sysdig\_secure\_account\_id) | ID of the Sysdig Cloud Account to add the integration to (incase of organization, ID of the Sysdig management account) | `string` | n/a | yes |
| <a name="input_component_instance_name"></a> [component\_instance\_name](#input\_component\_instance\_name) | Instance name of the Event Hub component to be created on the cloud account for Log Ingestion | `string` | n/a | yes |
| <a name="input_event_hub_name"></a> [event\_hub\_name](#input\_event\_hub\_name) | Display name of the existing Azure Event Hub to create the integration for | `string` | n/a | yes |
| <a name="input_event_hub_namespace"></a> [event\_hub\_namespace](#input\_event\_hub\_namespace) | Namespace of the existing Azure Event Hub to create the integration for | `string` | n/a | yes |
| <a name="input_consumer_group"></a> [consumer\_group](#input\_consumer\_group) | Name of the existing Azure consumer group to create the integration for | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_event_hub_component_id"></a> [event\_hub\_component\_id](#output\_event\_hub\_component\_id) | Component identifier of Event Hub used for Log Ingestion integration |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.
