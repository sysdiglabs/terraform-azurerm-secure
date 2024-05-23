variable "sysdig_secure_account_id" {
  type        = string
  description = "ID of the Sysdig Cloud Account to add the integration to (incase of organization, ID of the Sysdig management account)"
}

variable "component_instance_name" {
  type        = string
  description = "Instance name of the Event Hub component to be created on the cloud account for Log Ingestion"
}

variable "event_hub_name" {
  type        = string
  description = "Display name of the existing Azure Event Hub to create the integration for"
}

variable "event_hub_namespace" {
  type        = string
  description = "Namespace of the existing Azure Event Hub to create the integration for"
}

variable "consumer_group" {
  type        = string
  description = "Name of the existing Azure consumer group to create the integration for"
}