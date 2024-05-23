#---------------------------------------------------------------------------------------------
# Fetch the current service principal already existing in the customer tenant
#---------------------------------------------------------------------------------------------
data "azuread_service_principal" "current" {
  display_name = var.service_principal_display_name
}

#---------------------------------------------------------------------------------------------
# Call Sysdig Backend to add the service-principal integration to the Sysdig Cloud Account
#---------------------------------------------------------------------------------------------
resource "sysdig_secure_cloud_auth_account_component" "azure_service_principal" {
  account_id		             = var.sysdig_secure_account_id
  type                       = "COMPONENT_SERVICE_PRINCIPAL"
  instance                   = var.component_instance_name
  service_principal_metadata = jsonencode({
	  azure = {
		  active_directory_service_principal = {
				account_enabled           = true
        display_name              = data.azuread_service_principal.current.display_name
        id                        = data.azuread_service_principal.current.id
        app_display_name          = data.azuread_service_principal.current.display_name
        app_id                    = data.azuread_service_principal.current.client_id
        app_owner_organization_id = data.azuread_service_principal.current.application_tenant_id
		  }
	  }
  })
}