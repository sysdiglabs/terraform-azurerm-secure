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

variable "aks_discovery_permission_grant" {
    description = "(Optional) Set this field to 'true' to grant AKS discovery permissions to the secure-posture service principal."
    type        = bool
    default     = false
}

variable "sysdig_cspm_sp_object_id" {
    description = "Object ID of the CSPM SP within the client's infra"
    type = string
}

variable "sysdig_cspm_sp_display_name" {
  description = "Display name of the CSPM SP within the client's infra"
  type = string
}

variable "sysdig_cspm_sp_client_id" {
  description = "Client ID of the CSPM SP within the client's infra"
  type = string
}

variable "sysdig_cspm_sp_application_tenant_id" {
  description = "Application Tenant ID of the CSPM SP within the client's infra"
  type = string
}
