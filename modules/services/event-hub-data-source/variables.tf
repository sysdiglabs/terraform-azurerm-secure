variable "tenant_id" {
  type = string
  description = "Customer Tenant Id to onboard"
}

variable "subscription_id" {
  type = string
  description = "Subscription ID in which to create a trust relationship"
}

variable "sysdig_client_id" {
  type = string
  description = "Object ID of the enterprise application in the Sysdig tenant"
}

variable "partition_count" {
  description = "The number of partitions in the Event Hub"
  type        = number
  default     = 4
}