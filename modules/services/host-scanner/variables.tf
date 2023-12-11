variable "subscription_id" {
  type = string
  description = "Subscription ID in which to create a trust relationship"
}

variable "sysdig_tenant_id" {
  type = string
  description = "Sysdig Tenant ID"
}

variable "sysdig_service_principal_id" {
  type = string
  description = "Service Principal ID in the Sysdig tenant"
}
