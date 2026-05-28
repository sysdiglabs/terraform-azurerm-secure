#---------------------------------------------------------------------------------------------
# Ensure installation flow for foundational onboarding has been completed before
# installing additional Sysdig features.
#---------------------------------------------------------------------------------------------

module "event-hub" {
  source                   = "../../../modules/integrations/event-hub"
  subscription_id          = module.onboarding.subscription_id
  region                   = "West US"
  sysdig_secure_account_id = module.onboarding.sysdig_secure_account_id

  # Optional: pre-existing SP pointing to Sysdig thread detection App ID
  # event_hub_service_principal = "event-hub-service-principal-id"
}

resource "sysdig_secure_cloud_auth_account_feature" "threat_detection" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_THREAT_DETECTION"
  enabled    = true
  components = [module.event-hub.event_hub_component_id]
  depends_on = [ module.event-hub ]
}

# CIEM advanced (identity_entitlement with Event Hub) is not supported for single-subscription
# onboarding. CIEM requires tenant-level (organizational) onboarding with enable_ciem = true.
