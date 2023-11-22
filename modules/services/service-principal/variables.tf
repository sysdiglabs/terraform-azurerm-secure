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

# By default, this will be the root management group whose default display name is "Tenant root group"
variable "management_group" {
  description = "(Optional) Display name of the Azure Management Group. secure-for-cloud will be deployed to all the subscriptions under this management group."
  type        = string
  default     = "Tenant Root Group"
}
