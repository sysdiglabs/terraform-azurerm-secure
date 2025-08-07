variable "sysdig_secure_account_id" {
  type        = string
  description = "ID of the Sysdig Cloud Account to enable VM Workload Scanning with optional AKS discovery"
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
    TO BE DEPRECATED on 30th November, 2025: Please work with Sysdig to migrate to using `include_management_groups` instead.
    When set, restrict onboarding to a set of Azure Management Groups identifiers whose child management groups and subscriptions are to be onboarded.
    Default: onboard all management groups.
    EOF
  type        = set(string)
  default     = []
}

variable "aks_enabled" {
  description = "(Optional) Set this field to 'true' to grant AKS discovery permissions to the secure-posture service principal."
  type        = bool
  default     = false
}

variable "functions_enabled" {
  description = "(Optional) Set this field to 'true' to grant Functions Storage permissions to the secure-vm-workload-scanning service principal."
  type        = bool
  default     = false
}

variable "sysdig_cspm_sp_object_id" {
  description = "Object ID of the CSPM SP within the client's infra"
  type        = string
}

variable "vm_workload_scanning_service_principal" {
  description = "(Optional) Service Principal to be used for vm workload scanning. If not provided, a new one will be created."
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

