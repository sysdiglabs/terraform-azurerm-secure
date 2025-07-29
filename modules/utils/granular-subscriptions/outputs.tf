output "valid_mg_names_at_level" {
  description = "List of valid management group names at the current level after applying exclude filters. These are the management groups that will be used for discovering child management groups and subscriptions."
  value       = local.valid_mgs
}

output "child_management_group_ids" {
  description = "List of child management group IDs discovered from the input management groups. These can be used as input for the next level of recursive discovery."
  value       = local.child_mgs
}

output "subscriptions" {
  description = "List of subscription IDs discovered from the valid management groups after applying subscription filters. This is the final list of subscriptions that should receive resources."
  value       = local.subscriptions
}