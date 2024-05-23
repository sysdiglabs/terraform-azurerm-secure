#---------------------------------------------------------------------------------------------
# Call Sysdig Backend to add the event-hub integration to the Sysdig Cloud Account
#---------------------------------------------------------------------------------------------
resource "sysdig_secure_cloud_auth_account_component" "azure_event_hub" {
  account_id		             = var.sysdig_secure_account_id
  type                       = "COMPONENT_EVENT_BRIDGE"
  instance                   = var.component_instance_name
  event_bridge_metadata = jsonencode({
	  azure = {
		  event_hub_metadata= {
        event_hub_name      = var.event_hub_name
        event_hub_namespace = var.event_hub_namespace
        consumer_group      = var.consumer_group
      }
	  }
  })
}