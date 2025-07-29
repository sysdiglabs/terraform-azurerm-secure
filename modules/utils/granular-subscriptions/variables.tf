variable "management_group_ids" {
  description = "List of management group names to include for organization in the format '<management_group_id>' i.e: management_group_id_1"
  type        = list(string)
}

variable "exclude_management_groups" {
  description = "List of management group names to exclude for organization in the format '<management_group>' i.e: management_group_id_1"
  type        = set(string)
  default     = []
}

variable "include_subscriptions" {
  description = "List of subscription ids to include for organization in the format '<subscription_id>'"
  type        = set(string)
  default     = []
}

variable "exclude_subscriptions" {
  description = "List of subscription ids to exclude for organization in the format '<subscription_id>'"
  type        = set(string)
  default     = []
}