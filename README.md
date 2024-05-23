# Sysdig Secure for Cloud in Azure

Terraform module that deploys the Sysdig Secure for Cloud stack in Azure.

* **[Onboarding]**: It onboards an Azure subscription or Tenant for the first time to Sysdig Secure for Cloud, and collects
inventory and organizational hierarchy in the given tenanmt.Managed through `onboarding` module. <br/>

Provides unified threat-detection, compliance, forensics and analysis through these major components:

* **[CSPM](https://docs.sysdig.com/en/docs/sysdig-secure/posture/)**: It evaluates periodically your cloud configuration, using Cloud Custodian, against some benchmarks and returns the results and remediation you need to fix. Managed through `config-posture` module. <br/>

* **[CDR (Cloud Detection and Response)]**: It sends periodically activity logs to Sysdig by directing those to a dedicated Event Hub which will be queried by the Sysdig backend to retrieve the data for log ingestion. Managed through `threat-detection` module. <br/>

* **[Vulnerability Management Agentless Host Scanning](https://docs.sysdig.com/en/docs/sysdig-secure/vulnerabilities/)**: It uses disk snapshots to provide highly accurate views of vulnerability risk, access to public exploits, and risk management.  Managed through `agentless-scanning` module. <br/>

For other Cloud providers check: [AWS](https://github.com/draios/terraform-aws-secure-for-cloud) , [GCP](https://github.com/draios/terraform-google-secure-for-cloud)

## Integrations

The above modules deploy all the required resources for installing the respective features and onboarding the Azure
Subscription and/or Tenant to Sysdig Secure for Cloud.

The `integrations` module has sub-modules to deploy the required Sysdig side components for the onboarded Azure
Subscription and/or Tenant. These component integrations may or may not be shared among features.

## Examples and usage

The modules in this repository can be installed on a single Azure subscription, or on an entire Azure Tenant, or management groups within the Tenant.

The `test` directory has sample `examples` for all these module deployments i.e under `single_subscription`,  or `organization` sub-folders.

For example, to onboard a single Azure subscription, with CSPM enabled, with modular installation :-

1. Run the terraform snippet under `test/examples/modular_single_subscription/onboarding_with_posture.tf` with
   the appropriate attribute values populated.
2. This will install the `onboarding` module, which will also create a Cloud Account on Sysdig side.
3. It will also install the `config-posture` module, which will also install service-principal component `integration`.
4. On Sysdig side, you will be able to see the Cloud account onboarded with required components, and CSPM feature installed and enabled.

## Authors

Module is maintained and supported by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.
