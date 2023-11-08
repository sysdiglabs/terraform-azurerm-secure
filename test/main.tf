provider "azurerm" {
  features {}
}
terraform {
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = "~> 1.15.1"
    }
  }
}
module "project-posture" {
  source               = "../../modules/services/service-principal"
  project_id           = "sample"
  service_account_name = "sysdig-secure-jgso"
}

provider "sysdig" {
  sysdig_secure_url       = "https://secure-staging.sysdig.com"
  sysdig_secure_api_token = var.sysdig_secure_api_token
}

resource "sysdig_secure_cloud_auth_account" "azure_subscription_sample" {
  enabled       = true
  provider_id   = "changeme"
  provider_type = "PROVIDER_AZURE"
  provider_tenant_id = project-posture.subscription_tenant_id

  feature {

    secure_config_posture {
      enabled    = true
      components = ["COMPONENT_SERVICE_PRINCIPAL/secure-posture"]
    }
  }
  component {
    type     = "COMPONENT_SERVICE_PRINCIPAL"
    instance = "secure-posture"
  }
  service_principal_metadata = jsonencode({
    azure = {
      active_directory_service_principal = {
        account_enabled = true
        display_name    = project-posture.service_principal_display_name
        id              = project-posture.service_principal_id
      }
    }
  })
}
