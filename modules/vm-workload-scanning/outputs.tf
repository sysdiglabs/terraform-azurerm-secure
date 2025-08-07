output "service_principal_component_id" {
  value       = "${sysdig_secure_cloud_auth_account_component.azure_workload_scanning_component.type}/${sysdig_secure_cloud_auth_account_component.azure_workload_scanning_component.instance}"
  description = "Component identifier of VM Workload Scanning created in Sysdig Backend"
  depends_on  = [sysdig_secure_cloud_auth_account_component.azure_workload_scanning_component]
}