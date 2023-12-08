# Azure Agentless Host Scan Module

This module will deploy a LightHouse Definition and Assignment in Azure for a single subscription.

If instrumenting an Azure subscription, the following resources will be created:
- LightHouse Definition associated with Sysdig Service Principal and the VM Scanner Operator role.
- LightHouse Assignment associated with the LightHouse Definition and the Azure subscription provided.