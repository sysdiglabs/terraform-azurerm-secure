variable "subscription_id" {
  type        = string
  description = "Subscription ID in which to create a trust relationship"
}

variable "service_principal_id" {
  type        = string
  description = "Service Principal ID created by Sysdig in the customer's tenant"
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
