---
type: Terraform Component
title: Azure Managed Security
description: VNet injection with Secure Cluster Connectivity (No Public IP) — the simplest Azure tier.
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/networking/azure/managed-security
tags: [azure, networking, vnet-injection, scc]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

The simplest Azure networking tier: a VNet with host and container subnets plus the required NSG rules, for Secure Cluster Connectivity (No Public IP) workspaces.

# Modules Composed

- `azure-account-network-vnet`

# Key Inputs

`resource_group_name`, `location`, `vnet_name` (required); subnet CIDRs, `nsg_name`, `tags` (optional).

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/networking/azure/managed-security/README.md) for full inputs, outputs, and usage.
