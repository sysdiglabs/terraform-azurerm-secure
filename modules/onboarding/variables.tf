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

variable "onboarding_service_principal" {
  description = "(Optional) Service Principal to be used for onboarding. If not provided, a new one will be created."
  type        = string
  default     = ""
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

variable "enable_automatic_onboarding" {
  type        = bool
  default     = false
  description = "true/false whether Sysdig should automatically discover latest set of accounts in onboarded organization or not"
}

variable "use_existing_role_assignments" {
  description = "(Optional) set this to true when onboarding_service_principal is set and roles are already assigned to SP."
  type        = bool
  default     = false
}
