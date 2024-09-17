resource "sysdig_secure_cloud_auth_account_feature" "agentless-aca-aci-scanning" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_AGENTLESS_WORKLOAD_ACA_ACI_SCANNING"
  enabled    = true
  components = []
  depends_on = []
}