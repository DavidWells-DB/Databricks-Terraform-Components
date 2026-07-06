---
type: Terraform Component
title: GCP PSC Exfiltration Protection
description: Hub-spoke with Private Service Connect endpoints + deny-all egress to prevent exfiltration.
resource: https://github.com/DavidWells-DB/Databricks-Terraform-Components/tree/main/networking/gcp/psc-exfiltration-protection
tags: [gcp, networking, psc, exfiltration]
timestamp: 2026-07-06T00:00:00Z
---

# Summary

A hub-spoke architecture with Private Service Connect (PSC) endpoints for secure connectivity to the Databricks control plane, combined with deny-all egress firewall rules to prevent data exfiltration. All traffic to Databricks flows through PSC rather than the public internet.

# Modules Composed

- `gcp-account-network-vpc` (spoke)
- `gcp-account-network-psc-endpoints`

# Key Inputs

`databricks_account_id`, `project_id`, `region`, `resource_prefix` (required); spoke/hub CIDRs, `psc_subnet_cidr`, `google_apis_cidr`, `public_access_enabled` (optional).

See the [component README](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/networking/gcp/psc-exfiltration-protection/README.md) for full inputs, outputs, and usage.
