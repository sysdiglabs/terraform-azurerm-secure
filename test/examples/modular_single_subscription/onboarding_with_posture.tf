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
      version = "~> 1.28.0"
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
}

resource "sysdig_secure_cloud_auth_account_feature" "config_posture" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_CONFIG_POSTURE"
  enabled    = true
  components = [module.config-posture.service_principal_component_id]
}
