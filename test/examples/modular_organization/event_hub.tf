#---------------------------------------------------------------------------------------------
# Ensure installation flow for foundational onboarding has been completed before
# installing additional Sysdig features.
#---------------------------------------------------------------------------------------------

module "event-hub" {
  source                   = "../../../modules/integrations/event-hub"
  subscription_id          = module.onboarding.subscription_id
  region                   = "West US"
  sysdig_secure_account_id = module.onboarding.sysdig_secure_account_id
  is_organizational        = module.onboarding.is_organizational
  management_group_ids     = module.onboarding.management_group_ids
}

resource "sysdig_secure_cloud_auth_account_feature" "threat_detection" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_THREAT_DETECTION"
  enabled    = true
  components = [module.event-hub.event_hub_component_id]
  depends_on = [ module.event-hub ]
}

resource "sysdig_secure_cloud_auth_account_feature" "identity_entitlement_advanced" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_IDENTITY_ENTITLEMENT"
  enabled    = true
  components = concat(sysdig_secure_cloud_auth_account_feature.identity_entitlement_basic.components, [module.event-hub.event_hub_component_id])
  depends_on = [module.event-hub, sysdig_secure_cloud_auth_account_feature.identity_entitlement_basic]
  flags = {"CIEM_FEATURE_MODE": "advanced"}
}
