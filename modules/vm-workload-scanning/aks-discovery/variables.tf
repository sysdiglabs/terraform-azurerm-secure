# tflint-ignore: terraform_unused_declarations
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
  description = <<-EOF
    TO BE DEPRECATED: Please work with Sysdig to migrate to using `include_management_groups` instead.
    When set, restrict onboarding to a set of Azure Management Groups identifiers whose child management groups and subscriptions are to be onboarded.
    Default: onboard all management groups.
    EOF
  type        = set(string)
  default     = []
}

variable "sysdig_cspm_sp_object_id" {
  description = "Object ID of the CSPM SP within the client's infra"
  type        = string
}

variable "include_management_groups" {
  description = "(Optional) management groups to include for organization in the format '<management_group_idt>' i.e: management_group_id_1"
  type        = set(string)
  default     = []
}

variable "exclude_management_groups" {
  description = "(Optional) management groups to exclude for organization in the format '<management_group_idt>' i.e: management_group_id_1"
  type        = set(string)
  default     = []
}

variable "include_subscriptions" {
  description = "(Optional) subscription id to include for organization i.e: 12345678-1234-1234-1234-123456789abc"
  type        = set(string)
  default     = []
}

variable "exclude_subscriptions" {
  description = "(Optional) subscription id to exclude for organization i.e: 12345678-1234-1234-1234-123456789abc"
  type        = set(string)
  default     = []
}

variable "use_existing_role_assignments" {
  description = "(Optional) set this to true when roles are already assigned to SP"
  type        = bool
  default     = false
}
