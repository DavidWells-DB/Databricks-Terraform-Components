---
type: Terraform Component
title: Azure Hub-Spoke Firewall
description: Hub-spoke topology with Azure Firewall egress filtering, public front-end (no Private Link).
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/networking/azure/hub-spoke-firewall
tags: [azure, networking, firewall, hub-spoke, egress-control]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

A hub-spoke topology with Azure Firewall for egress filtering, without Private Link — a simpler alternative to `isolated` for customers who need egress control but not full private connectivity. Users reach the workspace over the public internet; data-plane egress is forced through the firewall. The hub VNet uses raw resources because AzureFirewallSubnet/GatewaySubnet cannot carry NSGs.

# Modules Composed

- `azure-account-network-vnet` (spoke)
- `azure-account-network-firewall`
- `azure-account-network-vnet-peering`

# Key Inputs

`resource_group_name`, `location`, `hub_vnet_name`, `spoke_vnet_name` (required); hub/spoke CIDRs, `firewall_name`, `service_tag_rules` (optional).

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/networking/azure/hub-spoke-firewall/README.md) for full inputs, outputs, and usage.
