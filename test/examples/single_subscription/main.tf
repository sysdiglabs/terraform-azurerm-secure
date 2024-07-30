provider "azurerm" {
  features {}
}
terraform {
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = "~> 1.24.2"
    }
  }
}

provider "sysdig" {
  sysdig_secure_url       = "https://secure-staging.sysdig.com"
  sysdig_secure_api_token = "<client_secret>"
}

module "subscription-posture" {
  source           = "../modules/services/service-principal"
  subscription_id  = "test-azure-provider"
  sysdig_client_id = "<sysdig_application_client_id>"
}


resource "sysdig_secure_cloud_auth_account" "azure_subscription_test" {
  enabled            = true
  provider_id        = "test-azure-provider"
  provider_type      = "PROVIDER_AZURE"
  provider_tenant_id = module.subscription-posture.subscription_tenant_id
  provider_alias     = module.subscription-posture.subscription_alias

  feature {

    secure_config_posture {
      enabled    = true
      components = ["COMPONENT_SERVICE_PRINCIPAL/secure-posture"]
    }
  }
  component {
    type     = "COMPONENT_SERVICE_PRINCIPAL"
    instance = "secure-posture"
    service_principal_metadata = jsonencode({
      azure = {
        active_directory_service_principal = {
          account_enabled           = true
          display_name              = module.subscription-posture.service_principal_display_name
          id                        = module.subscription-posture.service_principal_id
          app_display_name          = module.subscription-posture.service_principal_app_display_name
          app_id                    = module.subscription-posture.service_principal_client_id
          app_owner_organization_id = module.subscription-posture.service_principal_app_owner_organization_id
        }
      }
    })
  }
  depends_on = [module.subscription-posture]
}