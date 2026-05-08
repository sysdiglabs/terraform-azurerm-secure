variable "subscription_id" {
  type        = string
  description = "Subscription ID in which to create a trust relationship"
}

variable "is_organizational" {
  description = "(Optional) Set this field to 'true' to deploy secure-for-cloud to an Azure Tenant."
  type        = bool
  default     = false
}

variable "sysdig_secure_account_id" {
  type        = string
  description = "ID of the Sysdig Cloud Account to enable Agentless Scanning for (incase of organization, ID of the Sysdig management account)"
}

variable "include_management_groups" {
  description = "(Optional) management groups to include for organization in the format '<management_group_id>' i.e: management_group_id_1"
  type        = set(string)
  default     = []
}

variable "exclude_management_groups" {
  description = "(Optional) management groups to exclude for organization in the format '<management_group_id>' i.e: management_group_id_1"
  type        = set(string)
  default     = []
}

variable "include_subscriptions" {
  description = "(Optional) subscription ids to include for organization i.e: 12345678-1234-1234-1234-123456789abc"
  type        = set(string)
  default     = []
}

variable "exclude_subscriptions" {
  description = "(Optional) subscription ids to exclude for organization i.e: 12345678-1234-1234-1234-123456789abc"
  type        = set(string)
  default     = []
}
