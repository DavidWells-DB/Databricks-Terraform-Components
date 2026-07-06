---
type: Terraform Component
title: Azure Hardened Connectivity
description: VNet injection with back-end Private Link; front-end stays public.
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/networking/azure/hardened-connectivity
tags: [azure, networking, private-link, vnet-injection]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

VNet injection with back-end (data-plane) Private Link while keeping front-end access over the public internet. Users connect to the workspace UI publicly, but cluster-to-control-plane traffic goes over Private Link.

# Modules Composed

- `azure-account-network-vnet`
- `azure-account-network-private-endpoints`

# Key Inputs

`resource_group_name`, `location`, `vnet_name`, `workspace_resource_id` (required); subnet CIDRs including `pe_subnet_cidr` (optional).

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/networking/azure/hardened-connectivity/README.md) for full inputs, outputs, and usage.
