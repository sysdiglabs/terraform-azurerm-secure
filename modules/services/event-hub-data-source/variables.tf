variable "tenant_id" {
  description = "The ID of the tenant"
  type        = string
}

variable "event_hub_subscription_id" {
  description = "The ID of the subscription where to create the Event Hub"
  type        = string
}

/*
variable "subscription_ids" {
  description = "The IDs of the subscriptions"
  type        = list(string)
}
*/

variable "sysdig_client_id" {
  type = string
  description = "Application ID of the enterprise application in the Sysdig tenant"
  default = "07f34d7e-ff4e-44e0-aaa4-2560a5667166"
}

variable "partition_count" {
  description = "The number of partitions in the Event Hub"
  type        = number
  default     = 4
}