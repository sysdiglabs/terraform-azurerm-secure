variable "subscription_id" {
  type        = string
  description = "Subscription ID in which to create a trust relationship"
}

variable "sysdig_client_id" {
  type        = string
  description = "Service client ID in the Sysdig tenant"
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

variable "agentless_aks_connection_enabled" {
  type        = bool
  description = "Enable the Agentless AKS connection to the K8s clusters within the cloud. This allows admin access. Read more about why this is needed in the official docs."
  default     = false
}

variable "enable_ciem" {
  description = "(Optional) Set to 'true' to enable CIEM (Cloud Identity and Entitlement Management) for tenant-level onboarding. When enabled, the Sysdig Service Principal will be assigned the Entra ID Directory Readers role, which requires the installer to have Privileged Role Administrator permissions. Has no effect when is_organizational = false."
  type        = bool
  default     = true
}
