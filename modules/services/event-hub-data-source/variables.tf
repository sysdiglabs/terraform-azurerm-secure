variable "sysdig_client_id" {
  type        = string
  description = "Application ID of the enterprise application in the Sysdig tenant"
}

variable "partition_count" {
  description = "The number of partitions in the Event Hub"
  type        = number
  default     = 4
}

variable "message_retention_days" {
  description = "Number of days during which messages will be retained in the Event Hub"
  type        = number
  default     = 1
}

variable "location" {
  type        = string
  description = "Location where Sysdig-related resources will be created"
}
