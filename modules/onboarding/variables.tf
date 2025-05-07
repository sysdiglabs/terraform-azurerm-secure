variable "subscription_id" {
  type        = string
  description = "Subscription ID in which to create secure-for-cloud onboarding resources"
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID of which the subscription is part of"
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

variable "onboarding_service_principal" {
  description = "(Optional) Service Principal to be used for onboarding. If not provided, a new one will be created."
  type        = string
  default     = ""
}
