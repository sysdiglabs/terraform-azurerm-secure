variable "sysdig_client_id" {
  type = string
  description = "Application ID of the enterprise application in the Sysdig tenant"
}

variable "partition_count" {
  description = "The number of partitions in the Event Hub"
  type        = number
  default     = 4
}