provider "azurerm" {
  features { }
  subscription_id = "test-subscription"
  tenant_id       = "test-tenant"
}

provider "azuread" {
  tenant_id       = "test-tenant"
}

terraform {
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = "~> 1.48"
    }
  }
}

provider "sysdig" {
  sysdig_secure_url       = "https://secure-staging.sysdig.com"
  sysdig_secure_api_token = "<client_secret>"
}

module "onboarding" {
  source           = "../../../modules/onboarding"
  subscription_id  = "test-subscription"
  tenant_id        = "test-tenant"
}

module "config-posture" {
  source                   = "../../../modules/config-posture"
  subscription_id          = module.onboarding.subscription_id
  sysdig_secure_account_id = module.onboarding.sysdig_secure_account_id

  # Optional: pre-existing SP pointing to Sysdig CSPM App ID
  # config_posture_service_principal = "config-posture-service-principal-id"
}

resource "sysdig_secure_cloud_auth_account_feature" "config_posture" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_CONFIG_POSTURE"
  enabled    = true
  components = [module.config-posture.service_principal_component_id]
  depends_on = [ module.config-posture ]
}

resource "sysdig_secure_cloud_auth_account_feature" "identity_entitlement_basic" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_IDENTITY_ENTITLEMENT"
  enabled    = true
  components = [module.config-posture.service_principal_component_id]
  depends_on = [module.config-posture, sysdig_secure_cloud_auth_account_feature.config_posture]
  flags = {
    "CIEM_FEATURE_MODE": "basic"
  }

  lifecycle {
    ignore_changes = [flags, components]
  }
}
