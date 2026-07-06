---
type: Terraform Component
title: Azure NCC + Storage
description: NCC for serverless compute + VNet injection for classic compute; each half independently toggleable.
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/networking/azure/ncc-storage
tags: [azure, networking, ncc, serverless, vnet-injection]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

Sets up networking for both compute types: a Network Connectivity Config (NCC) for serverless and a VNet with subnets/NSG for classic compute. The two halves are independently toggleable via `enable_ncc` and `enable_vnet` (both default `true`) — set `enable_vnet = false` for serverless-only, or `enable_ncc = false` for classic-only.

# Modules Composed

- `azure-account-network-connectivity-config` (when `enable_ncc`)
- `azure-account-network-vnet` (when `enable_vnet`)

# Key Inputs

`enable_ncc`, `enable_vnet` (default true); when NCC enabled: `databricks_account_id`, `ncc_name`, `ncc_region`; when VNet enabled: `resource_group_name`, `location`, `vnet_name`.

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/networking/azure/ncc-storage/README.md) for full inputs, outputs, and usage.
