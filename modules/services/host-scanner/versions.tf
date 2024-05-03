terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.76.0, <= 3.101.0" //to remove , <= 3.101.0 after a fix is released for SSPROD-41225
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.43.0"
    }
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = ">= 1.19.0"
    }
  }
}
