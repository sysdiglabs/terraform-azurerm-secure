#---------------------------------------------------------------------------------------------
# Fetch the subscription data
#---------------------------------------------------------------------------------------------
data "azurerm_subscription" "sysdig_subscription" {
  subscription_id = var.subscription_id
}

data "sysdig_secure_trusted_azure_app" "threat_detection" {
	name = "threat_detection"
}

# Generate a unique hash for the subscription ID
locals {
  subscription_hash = substr(md5(data.azurerm_client_config.current.subscription_id), 0, 8)
}

# A random resource is used to generate unique Event Hub names.
# This prevents conflicts when recreating an Event Hub Namespace with the same name.
# Azure caches the Event Hub name after deletion.
# If the namespace is recreated, Azure restores the existing Event Hub, causing a Terraform apply failure.
resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}


#--------------------------------------------------------------------------------------------------------------
# Create service principal in customer tenant, using the Sysdig Managed Application for Threat Detection (CDR)
# used for event hub integration.
#
# If there is an existing service principal in the tenant, this will automatically import
# and use it, ensuring we have just one service principal linked to the Sysdig application
# in the customer tenant.
# Note: Please refer to the caveats of use_existing attribute for this resource.
#
# Note: Once created, this cannot be deleted via Terraform. It can be manually deleted from Azure.
#       This is to safeguard against unintended deletes if the service principal is in use.
#--------------------------------------------------------------------------------------------------------------
resource "azuread_service_principal" "sysdig_event_hub_sp" {
  client_id    = data.sysdig_secure_trusted_azure_app.threat_detection.application_id
  use_existing = true
  notes        = "Service Principal linked to the Sysdig Secure CNAPP - CDR module"
}

#---------------------------------------------------------------------------------------------
# Use an existing resource group for Sysdig resources
#---------------------------------------------------------------------------------------------
data "azurerm_resource_group" "existing" {
  count = var.resource_group != null ? 1 : 0
  name  = var.resource_group
}

#---------------------------------------------------------------------------------------------
# Create a resource group for Sysdig resources
#---------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "sysdig_resource_group" {
  count    = var.resource_group == null ? 1 : 0
  name     = "${var.resource_group_name}-${random_string.random.result}-${local.subscription_hash}"
  location = var.region
}

#---------------------------------------------------------------------------------------------
# Create an Event Hub Namespace for Sysdig
#---------------------------------------------------------------------------------------------
resource "azurerm_eventhub_namespace" "sysdig_event_hub_namespace" {
  name                     = "${var.event_hub_namespace_name}-${random_string.random.result}-${local.subscription_hash}"
  location                 = var.resource_group != null ? data.azurerm_resource_group.existing[0].location : azurerm_resource_group.sysdig_resource_group[0].location
  resource_group_name      = var.resource_group != null ? data.azurerm_resource_group.existing[0].name : azurerm_resource_group.sysdig_resource_group[0].name
  sku                      = var.namespace_sku
  capacity                 = var.throughput_units
  auto_inflate_enabled     = var.auto_inflate_enabled
  maximum_throughput_units = var.maximum_throughput_units
}


#---------------------------------------------------------------------------------------------
# Create an Event Hub within the Sysdig Namespace
#---------------------------------------------------------------------------------------------
resource "azurerm_eventhub" "sysdig_event_hub" {
  name                = "${var.event_hub_name}-${random_string.random.result}"
  namespace_name      = azurerm_eventhub_namespace.sysdig_event_hub_namespace.name
  resource_group_name = var.resource_group != null ? data.azurerm_resource_group.existing[0].name : azurerm_resource_group.sysdig_resource_group[0].name
  partition_count     = var.partition_count
  message_retention   = var.message_retention_days
}

#---------------------------------------------------------------------------------------------
# Create a Consumer Group within the Sysdig Event Hub
#---------------------------------------------------------------------------------------------
resource "azurerm_eventhub_consumer_group" "sysdig_consumer_group" {
  name                = var.consumer_group_name
  namespace_name      = azurerm_eventhub_namespace.sysdig_event_hub_namespace.name
  eventhub_name       = azurerm_eventhub.sysdig_event_hub.name
  resource_group_name = var.resource_group != null ? data.azurerm_resource_group.existing[0].name : azurerm_resource_group.sysdig_resource_group[0].name
}

#---------------------------------------------------------------------------------------------
# Create an Authorization Rule for the Sysdig Namespace
#---------------------------------------------------------------------------------------------
resource "azurerm_eventhub_namespace_authorization_rule" "sysdig_rule" {
  name                = var.eventhub_authorization_rule_name
  namespace_name      = azurerm_eventhub_namespace.sysdig_event_hub_namespace.name
  resource_group_name = var.resource_group != null ? data.azurerm_resource_group.existing[0].name : azurerm_resource_group.sysdig_resource_group[0].name

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
  principal_id         = azuread_service_principal.sysdig_event_hub_sp.object_id
}

#---------------------------------------------------------------------------------------------
# Create diagnostic settings for the subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "sysdig_diagnostic_setting" {
  count = length(var.enabled_platform_logs) > 0 && !var.is_organizational ? 1 : 0

  name                           = "${var.diagnostic_settings_name}-${random_string.random.result}-${local.subscription_hash}"
  target_resource_id             = data.azurerm_subscription.sysdig_subscription.id
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.sysdig_rule.id
  eventhub_name                  = azurerm_eventhub.sysdig_event_hub.name

  dynamic "enabled_log" {
    for_each = var.enabled_platform_logs
    content {
      category = enabled_log.value
    }
  }
}

resource "azurerm_monitor_aad_diagnostic_setting" "sysdig_entra_diagnostic_setting" {
  count = var.enable_entra && length(var.enabled_entra_logs) > 0 ? 1 : 0

  name                           = "${var.entra_diagnostic_settings_name}-${local.subscription_hash}"
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.sysdig_rule.id
  eventhub_name                  = azurerm_eventhub.sysdig_event_hub.name

  dynamic "enabled_log" {
    for_each = var.enabled_entra_logs
    content {
      category = enabled_log.value

      retention_policy {
        enabled = false
      }
    }
  }
}

#---------------------------------------------------------------------------------------------
# Call Sysdig Backend to add the event-hub integration to the Sysdig Cloud Account
#
# Note (optional): To ensure this gets called after all cloud resources are created, add
# explicit dependency using depends_on
#---------------------------------------------------------------------------------------------
resource "sysdig_secure_cloud_auth_account_component" "azure_event_hub" {
  account_id                 = var.sysdig_secure_account_id
  type                       = "COMPONENT_EVENT_BRIDGE"
  instance                   = "secure-runtime"
  event_bridge_metadata = jsonencode({
    azure = {
      event_hub_metadata = {
        event_hub_name      = azurerm_eventhub.sysdig_event_hub.name
        event_hub_namespace = azurerm_eventhub_namespace.sysdig_event_hub_namespace.name
        consumer_group      = azurerm_eventhub_consumer_group.sysdig_consumer_group.name
      }
      service_principal = {
        active_directory_service_principal = {
          account_enabled           = true
          display_name              = azuread_service_principal.sysdig_event_hub_sp.display_name
          id                        = azuread_service_principal.sysdig_event_hub_sp.id
          app_display_name          = azuread_service_principal.sysdig_event_hub_sp.display_name
          app_id                    = azuread_service_principal.sysdig_event_hub_sp.client_id
          app_owner_organization_id = azuread_service_principal.sysdig_event_hub_sp.application_tenant_id
        }
      }
    }
  })
}
