# TODO: Remove this at the end, check configuration possibilities
# Azure provider configuration
provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}

# NOTE: Check another auth method
data "azurerm_subscription" "current" {
  subscription_id = var.subscription_id
}

#---------------------------------------------------------------------------------------------
# Create service principal in customer tenant
#---------------------------------------------------------------------------------------------
resource "azuread_service_principal" "sysdig_service_principal" {
  # NOTE: Application ID of the APP
  client_id = var.sysdig_client_id
}

#---------------------------------------------------------------------------------------------
# Create a resource group for Sysdig resources
#---------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "sysdig_resource_group" {
  name     = "sysdig-resource-group"
  location = var.location
}

#---------------------------------------------------------------------------------------------
# Create an Event Hub Namespace for Sysdig
#---------------------------------------------------------------------------------------------
resource "azurerm_eventhub_namespace" "sysdig_event_hub_namespace" {
  name                = "sysdig-event-hub-namespace"
  location            = azurerm_resource_group.sysdig_resource_group.location
  resource_group_name = azurerm_resource_group.sysdig_resource_group.name
  // NOTE: Discuss which should be the default plan for the namespace (Basic, Standard, Premium)
  sku = var.namespace_sku
}

#---------------------------------------------------------------------------------------------
# Create an Event Hub within the Sysdig Namespace
#---------------------------------------------------------------------------------------------
resource "azurerm_eventhub" "sysdig_event_hub" {
  name                = "sysdig-event-hub"
  namespace_name      = azurerm_eventhub_namespace.sysdig_event_hub_namespace.name
  resource_group_name = azurerm_resource_group.sysdig_resource_group.name
  partition_count     = var.partition_count
  message_retention   = var.message_retention_days
}

#---------------------------------------------------------------------------------------------
# Create a Consumer Group within the Sysdig Event Hub
#---------------------------------------------------------------------------------------------
# NOTE: Check what exactly this is, do we need it one per subscription? Probably not
resource "azurerm_eventhub_consumer_group" "sysdig_consumer_group" {
  name                = "sysdig-consumer-group"
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
  principal_id         = azuread_service_principal.sysdig_service_principal.object_id
}

#---------------------------------------------------------------------------------------------
# Create diagnostic settings for the subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "sysdig_diagnostic_setting" {
  name                           = "sysdig-diagnostic-setting"
  target_resource_id             = data.azurerm_subscription.current.id
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.sysdig_rule.id
  eventhub_name                  = azurerm_eventhub.sysdig_event_hub.name

  # TODO: Double check that this is the minimum set required
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
