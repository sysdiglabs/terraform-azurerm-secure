variable "subscription_id" {
  type = string
  description = "Subscription ID in which to create a trust relationship"
}

variable "sysdig_client_id" {
  type = string
  description = "Service client ID in the Sysdig tenant"
}

variable "is_organizational" {
  description = "(Optional) Set this field to 'true' to deploy secure-for-cloud to an Azure Tenant."
  type        = bool
  default     = false
}