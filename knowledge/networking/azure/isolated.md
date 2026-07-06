---
type: Terraform Component
title: Azure Isolated
description: Full Private Link (front-end, back-end, browser auth) + Azure Firewall in a hub-spoke topology — most restrictive tier.
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/networking/azure/isolated
tags: [azure, networking, private-link, firewall, hub-spoke, isolated]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

The most restrictive Azure tier: all traffic (front-end, back-end, and browser authentication) traverses Private Link, and data-plane egress is forced through Azure Firewall in a hub-spoke topology. The hub VNet uses raw resources (AzureFirewallSubnet/GatewaySubnet cannot carry NSGs); one shared private-endpoint module owns the DNS zone, with a raw spoke back-end PE to avoid a duplicate zone / name collision.

# Modules Composed

- `azure-account-network-vnet` (spoke)
- `azure-account-network-firewall`
- `azure-account-network-private-endpoints`
- `azure-account-network-vnet-peering`

# Key Inputs

`resource_group_name`, `location`, `hub_vnet_name`, `spoke_vnet_name`, `workspace_resource_id` (required); hub/spoke/PE CIDRs, `firewall_name` (optional).

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/networking/azure/isolated/README.md) for full inputs, outputs, and usage.
