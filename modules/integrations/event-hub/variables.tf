variable "subscription_id" {
  type        = string
  description = "Identifier of the subscription to be onboarded"
}

variable "region" {
  type        = string
  description = "Datacenter where Sysdig-related resources will be created"
}

variable "partition_count" {
  description = "The number of partitions in the Event Hub"
  type        = number
  default     = 4
}

variable "throughput_units" {
  description = "The number of throughput units to be allocated to the Event Hub"
  type        = number
  default     = 1
}

variable "maximum_throughput_units" {
  description = "The maximum number of throughput units to be allocated to the Event Hub"
  type        = number
  default     = 20
}

variable "auto_inflate_enabled" {
  description = "Whether or not auto-inflate is enabled for the Event Hub"
  type        = bool
  default     = true
}

variable "message_retention_days" {
  description = "Number of days during which messages will be retained in the Event Hub"
  type        = number
  default     = 1
}

variable "namespace_sku" {
  type        = string
  description = "SKU (Plan) for the namespace that will be created"
  default     = "Standard"
}

variable "event_hub_namespace_name" {
  type        = string
  description = "Name of the Event Hub Namespace to be created"
  default     = "sysdig-event-hub-namespace"
}

variable "event_hub_name" {
  type        = string
  description = "Name of the Event Hub to be created"
  default     = "sysdig-event-hub"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to be created"
  default     = "sysdig-resource-group"
}

variable "resource_group" {
  type        = string
  description = "Name of the existing resource group"
  default     = null
}

variable "consumer_group_name" {
  type        = string
  description = "Name of the consumer group to be created"
  default     = "sysdig-consumer-group"
}

variable "eventhub_authorization_rule_name" {
  type        = string
  description = "Name of the authorization rule to be created"
  default     = "sysdig-send-listen-rule"
}

variable "diagnostic_settings_name" {
  type        = string
  description = "Name of the diagnostic settings to be created"
  default     = "sysdig-diagnostic-settings"
}

variable "entra_diagnostic_settings_name" {
  type        = string
  description = "Name of the Entra diagnostic settings to be created"
  default     = "sysdig-entra-diagnostic-settings"
}

variable "is_organizational" {
  description = "(Optional) Set this field to 'true' to deploy secure-for-cloud to an Azure Tenant."
  type        = bool
  default     = false
}

variable "management_group_ids" {
  description = "(Optional) List of Azure Management Group IDs. secure-for-cloud will be deployed to all the subscriptions under these management groups."
  type        = set(string)
  default     = []
}

variable "enable_entra_single_subscription" {
  description = "(Optional) Used to enable or disable Entra logs for single subscription, defaults to false."
  type        = bool
  default     = false
}

variable "enable_entra_organization" {
  description = "(Optional) Used to enable or disable Entra logs for organizations, defaults to true."
  type        = bool
  default     = true
}

variable "sysdig_secure_account_id" {
  type        = string
  description = "ID of the Sysdig Cloud Account to enable Event Hub integration for (incase of organization, ID of the Sysdig management account)"
}