provider "azurerm" {
  features {}
}
terraform {
  required_providers {
    sysdig = {
      source = "local/sysdiglabs/sysdig"
      version = "~> 1.0.0"
    }
  }
}

provider "sysdig" {
  sysdig_secure_url       = "https://secure-staging.sysdig.com"
  sysdig_secure_api_token = "6f9cb282-b956-41a5-b213-eaac199a9881"
}

module "project-posture" {
  source                = "../modules/service-principal"
  subscription_id       = "db4d1aaa-4d7f-47d8-b0fe-445d0d70ffce"
  sysdig_application_id = "a39a3795-c3d7-4c8b-9c1a-24ea5011be8a"
}


resource "sysdig_secure_cloud_auth_account" "azure_subscription_test" {
  enabled = true
  provider_id = "test-azure-provider"
  provider_type = "PROVIDER_AZURE"
  provider_tenant_id = module.project-posture.subscription_tenant_id

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
          display_name              = module.project-posture.service_principal_display_name
          id                        = module.project-posture.service_principal_id
          app_display_name          = module.project-posture.service_principal_app_display_name
          app_id                    = module.project-posture.service_principal_app_id
          app_owner_organization_id = module.project-posture.service_principal_app_owner_organization_id
        }
      }
    })
  }
}