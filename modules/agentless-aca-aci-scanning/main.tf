resource "sysdig_secure_cloud_auth_account_feature" "agentless-aca-aci-scanning" {
  for_each = local.subscriptions

  account_id = "${each.value}"
  type       = "FEATURE_SECURE_AGENTLESS_SCANNING_WORKLOAD_AZURE_ACA_ACI"
  enabled    = true
  components = []
  depends_on = []
}