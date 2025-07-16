#---------------------------------------------------------------------------------------------
# Ensure installation flow for foundational onboarding has been completed before
# installing additional Sysdig features.
#---------------------------------------------------------------------------------------------

module "agentless-scanning" {
  source                      = "../../../modules/agentless-scanning"
  subscription_id             = module.onboarding.subscription_id
  sysdig_secure_account_id    = module.onboarding.sysdig_secure_account_id
  is_organizational           = module.onboarding.is_organizational
  management_group_ids        = module.onboarding.management_group_ids

  # Include/Exclude specific parameters from onboarding module
  include_management_groups = module.onboarding.include_management_groups
  exclude_management_groups = module.onboarding.exclude_management_groups
  include_subscriptions = module.onboarding.include_subscriptions
  exclude_subscriptions = module.onboarding.exclude_subscriptions
}

resource "sysdig_secure_cloud_auth_account_feature" "agentless_scanning" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_AGENTLESS_SCANNING"
  enabled    = true
  components = [module.agentless-scanning.service_principal_component_id]
  depends_on = [ module.agentless-scanning ]
}
