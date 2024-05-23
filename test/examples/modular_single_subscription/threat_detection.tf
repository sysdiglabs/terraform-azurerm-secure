#---------------------------------------------------------------------------------------------
# Ensure installation flow for foundational onboarding has been completed before
# installing additional Sysdig features.
#---------------------------------------------------------------------------------------------

module "threat-detection" {
  source                   = "../../../modules/threat-detection"
  subscription_id          = "test-subscription"
  region                   = "West US"
  sysdig_client_id         = "<sysdig_application_client_id>"
  event_hub_namespace_name = "sysdig-secure-events-abcd"
  resource_group_name      = "sysdig-secure-events-abcd"
  diagnostic_settings_name = "sysdig-secure-events-abcd"
  sysdig_secure_account_id = module.onboarding.sysdig_secure_account_id
}

resource "sysdig_secure_cloud_auth_account_feature" "threat_detection" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_THREAT_DETECTION"
  enabled    = true
  components = [module.threat-detection.event_hub_component_id]
}
