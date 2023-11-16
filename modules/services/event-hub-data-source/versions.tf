terraform {
    required_version = ">= 1.5.7"

    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "3.80.0"
        }
        azuread = {
            source  = "hashicorp/azuread"
            version = "2.45.0"
        }
        external = {
            source  = "hashicorp/external"
            version = "2.3.1"
        }
    }
}