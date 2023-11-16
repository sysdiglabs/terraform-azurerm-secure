variable "tenant_id" {
  type        = string
  description = "Identifier of the Azure tenant"
}

variable "subscription_id" {
  type        = string
  description = "Identifier of the subscription to be onboarded"
}

variable "sysdig_client_id" {
  type        = string
  description = "Application ID of the enterprise application in the Sysdig tenant"
  default = "07f34d7e-ff4e-44e0-aaa4-2560a5667166"
}

variable "location" {
  type        = string
  description = "Location where Sysdig-related resources will be created"
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

variable "namespace_sku" {
  type        = string
  description = "SKU (Plan) for the namespace that will be created"
  default     = "Standard"
}

