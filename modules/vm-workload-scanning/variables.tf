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
  description = "(Optional) List of Azure Management Group IDs. secure-for-cloud will be deployed to all the subscriptions under these management groups."
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
    type = string
}

variable "vm_workload_scanning_service_principal" {
  description = "(Optional) Service Principal to be used for vm workload scanning. If not provided, a new one will be created."
  type        = string
  default     = ""
}
