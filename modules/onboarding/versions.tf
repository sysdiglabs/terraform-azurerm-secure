terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.76.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.43.0"
    }
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = ">= 1.28.5"
    }
  }
}