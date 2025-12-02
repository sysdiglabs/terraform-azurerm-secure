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

output "include_management_groups" {
  description = "management_groups to include for organization"
  value       = var.include_management_groups
}

output "exclude_management_groups" {
  description = "management_groups to exclude for organization"
  value       = var.exclude_management_groups
}

output "include_subscriptions" {
  description = "subscriptions to include for organization"
  value       = var.include_subscriptions
}

output "exclude_subscriptions" {
  description = "subscriptions to exclude for organization"
  value       = var.exclude_subscriptions
}

