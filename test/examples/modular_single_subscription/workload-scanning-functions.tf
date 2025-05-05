#---------------------------------------------------------------------------------------------
# Ensure installation flow for foundational onboarding has been completed before
# installing additional Sysdig features.
#---------------------------------------------------------------------------------------------

module "vm-workload-scanning" {
  source                      = "sysdiglabs/secure/azurerm//modules/vm-workload-scanning"
  subscription_id             = module.onboarding.subscription_id
  sysdig_secure_account_id    = module.onboarding.sysdig_secure_account_id

  sysdig_cspm_sp_object_id = module.config-posture.sysdig_cspm_sp_object_id

  aks_enabled = false
  functions_enabled = true

  # Optional: pre-existing SP pointing to Sysdig VM Workload Scanning Application ID
  # vm_workload_scanning_service_principal = "vm-workload-scanning-service-principal-id"
}

resource "sysdig_secure_cloud_auth_account_feature" "vm-workload-scanning-functions" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_WORKLOAD_SCANNING_FUNCTIONS"
  enabled    = true
  components = [module.vm-workload-scanning.service_principal_component_id]
  depends_on = [ module.vm-workload-scanning ]
}
