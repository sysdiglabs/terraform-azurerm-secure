# Azure provider configuration
provider "azurerm" {
    features {}
}

provider "azuread" {
  tenant_id = var.tenant_id
}

# Fetching the subscription details
data "azurerm_subscription" "primary" {
    subscription_id = var.subscription_id
}

#---------------------------------------------------------------------------------------------
# Create service principal in customer tenant
#---------------------------------------------------------------------------------------------
resource "azuread_service_principal" "sysdig_sp" {
    client_id = var.sysdig_client_id
}

#---------------------------------------------------------------------------------------------
# Create a resource group for Sysdig resources
#---------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "sysdig_resource_group" {
        name     = "sysdig-resources"
        location = "West Europe"
}

#---------------------------------------------------------------------------------------------
# Create an Event Hub Namespace for Sysdig
#---------------------------------------------------------------------------------------------
resource "azurerm_eventhub_namespace" "sysdig_event_hub_namespace" {
        name                = "sysdig-event-hub-namespace"
        location            = azurerm_resource_group.sysdig_resource_group.location
        resource_group_name = azurerm_resource_group.sysdig_resource_group.name
        sku                 = "Standard"
}

#---------------------------------------------------------------------------------------------
# Create an Event Hub within the Sysdig Namespace
#---------------------------------------------------------------------------------------------
resource "azurerm_eventhub" "sysdig_event_hub" {
        name                = "sysdigeventhub"
        namespace_name      = azurerm_eventhub_namespace.sysdig_event_hub_namespace.name
        resource_group_name = azurerm_resource_group.sysdig_resource_group.name
        partition_count     = var.partition_count  
        message_retention   = 1  //days
}

#---------------------------------------------------------------------------------------------
# Create a Consumer Group within the Sysdig Event Hub
#---------------------------------------------------------------------------------------------
resource "azurerm_eventhub_consumer_group" "sysdig_consumer_group" {
        name                = "sysdig"
        namespace_name      = azurerm_eventhub_namespace.sysdig_event_hub_namespace.name
        eventhub_name       = azurerm_eventhub.sysdig_event_hub.name
        resource_group_name = azurerm_resource_group.sysdig_resource_group.name
}

#---------------------------------------------------------------------------------------------
# Create an Authorization Rule for the Sysdig Namespace
#---------------------------------------------------------------------------------------------
resource "azurerm_eventhub_namespace_authorization_rule" "sysdig_rule" {
        name                = "sysdig-send-listen-rule"
        namespace_name      = azurerm_eventhub_namespace.sysdig_event_hub_namespace.name
        resource_group_name = azurerm_resource_group.sysdig_resource_group.name

        listen = true
        send   = true
        manage = false
}

#---------------------------------------------------------------------------------------------
# Assign "Azure Event Hubs Data Receiver" role to Sysdig SP for the Event Hub Namespace
#---------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sysdig_data_receiver" {
    scope                = azurerm_eventhub_namespace.sysdig_event_hub_namespace.id
    role_definition_name = "Azure Event Hubs Data Receiver"
    principal_id         = azuread_service_principal.sysdig_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Create diagnostic settings for the subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "example" {
    name                       = "example-setting"
    target_resource_id         = data.azurerm_subscription.primary.id
    eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.sysdig_rule.id
    eventhub_name              = azurerm_eventhub.sysdig_event_hub.name

    enabled_log {
        category = "Administrative"
    }

    enabled_log {
        category = "Security"
    }

    enabled_log {
        category = "ServiceHealth"
    }

    enabled_log {
        category = "Alert"
    }

    enabled_log {
        category = "Recommendation"
    }

    enabled_log {
        category = "Policy"
    }

    enabled_log {
        category = "Autoscale"
    }

    enabled_log {
        category = "ResourceHealth"
    } 
}
