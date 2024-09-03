# Sysdig Secure for Cloud in Azure

Terraform module that deploys the Sysdig Secure for Cloud stack in Azure.

With Modular Onboarding, introducing the following design and install structure for `terraform-azurerm-secure`:

* **[Onboarding]**: It onboards an Azure subscription or Tenant for the first time to Sysdig Secure for Cloud, and collects
inventory and organizational hierarchy in the given tenant. Managed through `onboarding` module. <br/>

Provides unified threat-detection, compliance, forensics and analysis through these major components:

* **[CSPM](https://docs.sysdig.com/en/docs/sysdig-secure/posture/)**: It evaluates periodically your cloud configuration, using Cloud Custodian, against some benchmarks and returns the results and remediation you need to fix. Managed through `config-posture` module. <br/>

* **[CDR (Cloud Detection and Response)](https://docs.sysdig.com/en/docs/sysdig-secure/threats/activity/events-feed/)**: It sends periodically activity logs to Sysdig by directing those to a dedicated Event Hub which will be queried by the Sysdig backend to retrieve the data for log ingestion. Enabled via `event-hub` integrations module. <br/>

* **[Vulnerability Management Agentless Host Scanning](https://docs.sysdig.com/en/docs/sysdig-secure/vulnerabilities/)**: It uses disk snapshots to provide highly accurate views of vulnerability risk, access to public exploits, and risk management.  Managed through `agentless-scanning` module. <br/>

For other Cloud providers check: [AWS](https://github.com/draios/terraform-aws-secure-for-cloud) , [GCP](https://github.com/draios/terraform-google-secure-for-cloud)

## Modules

### Feature modules

These are independent feature modules which deploy and manage all the required Cloud resources and Sysdig resources
for the respective Sysdig features. They manage both, onboarding a single Azure Subscription or an Azure Tenant to Sysdig Secure for Cloud.

`onboarding`, `config-posture` and `agentless-scanning` are independent feature modules.

### Integrations

The modules under `integrations` are feature agnostic modules which deploy and manage all the required Cloud resources and Sysdig resources
for shared Sysdig integrations. That is to say, one or more Sysdig features can be enabled by installing an integration.

These modules manage both, onboarding a single Azure Subscription or an Azure Tenant to Sysdig Secure for Cloud.

`event-hub` is an integration module.

## Examples and usage

The modules in this repository can be installed on a single Azure subscription, or on an entire Azure Tenant, or management groups within the Tenant.

The `test` directory has sample `examples` for all these module deployments i.e under `single_subscription`,  or `organization` sub-folders.

For example, to onboard a single Azure subscription, with CSPM enabled, with modular installation :-
1. Run the terraform snippet under `test/examples/modular_single_subscription/onboarding_with_posture.tf` with
   the appropriate attribute values populated.
2. This will install the `onboarding` module, which will also create a Cloud Account on Sysdig side.
3. It will also install the `config-posture` module, which will also install cloud resources as well as Sysdig resources
   for successfully running CSPM scans.
4. On Sysdig side, you will be able to see the Cloud account onboarded with required components, and CSPM feature installed and enabled.

## Best practices

For contributing to existing modules or adding new modules, below are some of the best practices recommended :-
* Module names referred and used in deployment snippets should be consistent with those in their source path.
* A module can fall into one of two categories - feature module or an integrations module.
* Every user-facing deployment snippet will,
  - at the top level first call the feature module or integrations module from this repo. These modules deploy corresponding cloud resources and Sysdig component resources.
  - the corresponding feature resource will be added as the last block and enabled from the module installed component resource reference.
  See sample deployment snippets in `test/examples` for more.
* integrations modules are shared and could enable multiple features. Hence, one should be careful with changes to them.
* Module naming follows the pattern with "-" , resource and variable naming follows the pattern with "_".

## Authors

Module is maintained and supported by [Sysdig](https://sysdig.com).

## License

Apache 2 Licensed. See LICENSE for full details.
