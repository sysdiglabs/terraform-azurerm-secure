output "subscription_id" {
  value       = var.subscription_id
  description = "Subscription ID in which secure-for-cloud onboarding resources are created. For organizational installs it is the Management Subscription ID"
}

output "sysdig_secure_account_id" {
  value       = sysdig_secure_cloud_auth_account.azure_account.id
  description = "ID of the Sysdig Cloud Account created"
}

output "is_organizational" {
  value       = var.is_organizational
  description = "Boolean value to indicate if secure-for-cloud is deployed to an entire Azure Tenant or not"
}

output "management_group_ids" {
  value       = var.management_group_ids
  description = "List of Azure Management Group IDs on which secure-for-cloud is deployed"
}
