#---------------------------------------------------------------------------------------------
# Ensure installation flow for foundational onboarding has been completed before
# installing additional Sysdig features.
#---------------------------------------------------------------------------------------------

module "vm-workload-scanning" {
  source                      = "sysdiglabs/secure/azurerm//modules/vm-workload-scanning"
  subscription_id             = module.onboarding.subscription_id
  sysdig_secure_account_id    = module.onboarding.sysdig_secure_account_id
  is_organizational           = module.onboarding.is_organizational
  management_group_ids        = module.onboarding.management_group_ids

  sysdig_cspm_sp_object_id = module.config-posture.sysdig_cspm_sp_object_id

  aks_enabled = true
  functions_enabled = true
}

resource "sysdig_secure_cloud_auth_account_feature" "vm-workload-scanning-aca-aci" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_WORKLOAD_SCANNING_CONTAINERS"
  enabled    = true
  components = [module.vm-workload-scanning.service_principal_component_id]
  depends_on = [ module.vm-workload-scanning ]
}
