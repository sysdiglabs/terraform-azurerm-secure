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
      source  = "local/sysdiglabs/sysdig"
      version = "~> 1.0.0"
    }
  }
}

provider "sysdig" {
  sysdig_secure_url       = "https://secure-staging.sysdig.com"
  sysdig_secure_api_token = "<client_secret>"
}

module "onboarding" {
  source           = "../modules/onboarding"
  subscription_id  = "test-subscription"
  tenant_id        = "test-tenant"
  sysdig_client_id = "<sysdig_application_client_id>"
}

module "single-posture" {
  source                   = "../modules/integrations/service-principal"
  subscription_id          = "test-subscription"
  sysdig_client_id         = "<sysdig_application_client_id>"
  sysdig_secure_account_id = module.onboarding.sysdig_secure_account_id
}

resource "sysdig_secure_cloud_auth_account_feature" "config_posture" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_CONFIG_POSTURE"
  enabled    = true
  components = [module.single-posture.service_principal_component_id]
}
