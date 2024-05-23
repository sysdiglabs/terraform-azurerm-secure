variable "sysdig_secure_account_id" {
  type        = string
  description = "ID of the Sysdig Cloud Account to add the integration to (incase of organization, ID of the Sysdig management account)"
}

variable "component_instance_name" {
  type        = string
  description = "Instance name of the Service Principal component to be created on the cloud account"
}

variable "service_principal_display_name" {
  type        = string
  description = "Display name of the existing Azure Service Principal to create the integration for"
}