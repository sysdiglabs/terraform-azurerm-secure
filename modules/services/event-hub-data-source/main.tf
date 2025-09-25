#---------------------------------------------------------------------------------------------
# Fetch the subscription data
#---------------------------------------------------------------------------------------------
data "azurerm_subscription" "sysdig_subscription" {
  subscription_id = var.subscription_id
}

# Generate a unique hash for the subscription ID
locals {
  subscription_hash = substr(md5(data.azurerm_client_config.current.subscription_id), 0, 8)
}

# A random resource is used to generate unique Event Hub names.
# This prevents conflicts when recreating an Event Hub Namespace with the same name.
# Azure caches the Event Hub name after deletion.
# If the namespace is recreated, Azure restores the existing Event Hub, causing a Terraform apply failure.
# tflint-ignore: terraform_required_providers
resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}


#---------------------------------------------------------------------------------------------
# Create service principal in customer tenant
#---------------------------------------------------------------------------------------------
resource "azuread_service_principal" "sysdig_service_principal" {
  client_id    = var.sysdig_client_id
  use_existing = true
  lifecycle {
    prevent_destroy = true
  }
  notes = "Service Principal linked to the Sysdig Secure CNAPP"
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
  name     = "${var.resource_group_name}-${local.subscription_hash}"
  location = var.region
}

#---------------------------------------------------------------------------------------------
# Create an Event Hub Namespace for Sysdig
#---------------------------------------------------------------------------------------------
resource "azurerm_eventhub_namespace" "sysdig_event_hub_namespace" {
  name                     = "${var.event_hub_namespace_name}-${local.subscription_hash}"
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
  principal_id         = azuread_service_principal.sysdig_service_principal.object_id
}

#---------------------------------------------------------------------------------------------
# Create diagnostic settings for the subscription
#---------------------------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "sysdig_diagnostic_setting" {
  count = var.is_organizational ? 0 : 1

  name                           = "${var.diagnostic_settings_name}-${local.subscription_hash}"
  target_resource_id             = data.azurerm_subscription.sysdig_subscription.id
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.sysdig_rule.id
  eventhub_name                  = azurerm_eventhub.sysdig_event_hub.name

  enabled_log {
    category = "Administrative"
  }

  enabled_log {
    category = "Security"
  }

  enabled_log {
    category = "Policy"
  }
}

resource "azurerm_monitor_aad_diagnostic_setting" "sysdig_entra_diagnostic_setting" {
  count = var.enable_entra ? 1 : 0

  name                           = "${var.entra_diagnostic_settings_name}-${local.subscription_hash}"
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.sysdig_rule.id
  eventhub_name                  = azurerm_eventhub.sysdig_event_hub.name

  enabled_log {
    category = "AuditLogs"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "SignInLogs"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "NonInteractiveUserSignInLogs"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "ServicePrincipalSignInLogs"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "ManagedIdentitySignInLogs"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "ProvisioningLogs"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "ADFSSignInLogs"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "RiskyUsers"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "UserRiskEvents"


    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "NetworkAccessTrafficLogs"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "RiskyServicePrincipals"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "ServicePrincipalRiskEvents"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "EnrichedOffice365AuditLogs"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "MicrosoftGraphActivityLogs"

    retention_policy {
      enabled = false
    }
  }

  enabled_log {
    category = "RemoteNetworkHealthLogs"

    retention_policy {
      enabled = false
    }
  }
}
