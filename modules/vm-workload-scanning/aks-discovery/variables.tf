variable "sysdig_secure_account_id" {
  type        = string
  description = "ID of the Sysdig Cloud Account to enable Config Posture for (incase of organization, ID of the Sysdig management account)"
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID in which to create secure-for-cloud onboarding resources"
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

variable "sysdig_cspm_sp_object_id" {
  description = "Object ID of the CSPM SP within the client's infra"
  type = string
}