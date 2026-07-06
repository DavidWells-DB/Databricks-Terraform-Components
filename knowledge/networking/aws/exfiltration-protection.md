---
type: Terraform Component
title: AWS Exfiltration Protection
description: Hub-spoke with Transit Gateway + Network Firewall for defense-in-depth egress control, optional PrivateLink.
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/networking/aws/exfiltration-protection
tags: [aws, networking, firewall, transit-gateway, privatelink, exfiltration]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

A hub-spoke architecture using AWS Transit Gateway with Network Firewall in the hub for inspected egress — defense-in-depth against data exfiltration. The spoke VPC hosts Databricks workloads with optional backend PrivateLink (`enable_privatelink`). Supports [AWS GovCloud](/sovereign-clouds.md) via `databricks_gov_shard`.

# Modules Composed

- `aws-account-network-vpc` (hub + spoke)
- `aws-account-network-transit-gateway`
- `aws-account-network-firewall`
- `aws-account-network-egress-internet`
- `aws-account-network-vpc-endpoints`
- `aws-account-network-privatelink-endpoints` (when `enable_privatelink`)

# Key Inputs

`databricks_account_id`, `region`, `resource_prefix` (required); hub/spoke CIDRs, `tgw_asn`, `enable_privatelink`, `databricks_gov_shard` (optional).

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/networking/aws/exfiltration-protection/README.md) for full inputs, outputs, and usage.
