#---------------------------------------------------------------------------------------------
# Ensure installation flow for foundational onboarding has been completed before
# installing additional Sysdig features.
#---------------------------------------------------------------------------------------------

module "agentless-scanning" {
  source                      = "../../../modules/agentless-scanning"
  subscription_id             = "test-subscription"
  sysdig_tenant_id            = "<sysdig_application_tenant_id>"
  sysdig_service_principal_id = "<sysdig_application_sp_id>"
}

resource "sysdig_secure_cloud_auth_account_feature" "agentless_scanning" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_AGENTLESS_SCANNING"
  enabled    = true
  components = [module.config-posture.service_principal_component_id] // this feature gets enabled with a shared component
}
