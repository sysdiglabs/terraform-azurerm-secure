variable "sysdig_authorization_id" {
  type        = string
  description = "Identifier of Authorization Rule for the Sysdig Namespace"
}

variable "event_hub_name" {
  type        = string
  description = "Event Hub integration created for Sysdig Log Ingestion"
}

variable "diagnostic_settings" {
  type        = map(list(string))
  description = "Map of resource IDs to the list of logs to enable"
  default     = {}
}

variable "deployment_identifier" {
  type        = string
  description = "Identifier of Deployment that gets added to provisioned resources"
}
