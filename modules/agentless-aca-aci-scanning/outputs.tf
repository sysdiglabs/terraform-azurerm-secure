output "subscription_id" {
  value       = var.subscription_id
  description = "Subscription ID in which secure-for-cloud onboarding resources are created. For organizational installs it is the Management Subscription ID"
}

output "is_organizational" {
  value       = var.is_organizational
  description = "Boolean value to indicate if secure-for-cloud is deployed to an entire Azure Tenant or not"
}

output "management_group_ids" {
  value       = var.management_group_ids
  description = "List of Azure Management Group IDs on which secure-for-cloud is deployed"
}