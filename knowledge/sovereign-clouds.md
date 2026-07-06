---
type: Reference
title: Sovereign & Regulated Cloud Support
description: Databricks government/FedRAMP offerings per cloud and how these components support them.
tags: [govcloud, fedramp, azure-government, il5, compliance]
timestamp: 2026-07-06T00:00:00Z
---

# Databricks government offerings (verified)

| Cloud | Offering | Status |
|-------|----------|--------|
| AWS Commercial | FedRAMP Moderate | GA (us-east-1/2, us-west-1/2) |
| AWS GovCloud | FedRAMP High + DoD IL5 | GA (us-gov-west-1); DoD and Government Community offerings |
| Azure Government (MAG) | FedRAMP High | GA (usgovvirginia, usgovarizona) |
| Azure Commercial | FedRAMP High | Rolling out (2026) |
| GCP | US government / FedRAMP | None |

# How the components support it

- **AWS** — supported and parameterized. The AWS networking and Unity Catalog components thread `databricks_gov_shard` (`null` / `civilian` / `dod`) and `aws_partition` (`aws` / `aws-us-gov`), which switch the Databricks account host and the Databricks-managed IAM identities baked into trust policies. See the [GovCloud guide](https://github.com/DavidWells-DB/Databricks-Terraform-Components/blob/main/docs/GOVCLOUD.md).
- **Azure** — a real gap. Azure Databricks Gov (MAG) exists and is FedRAMP High, but the Azure components are commercial-only (no `azure_environment` switch; the modules hardcode the commercial `privatelink.azuredatabricks.net` DNS zone). Note that MAG regions do **not** support Unity Catalog or Databricks SQL, so only the Azure *networking* components are relevant there.
- **GCP** — not a gap; Databricks offers no US-government GCP, so commercial-only is correct.

# Terminology

FedRAMP is a compliance *authorization*, not a separate deployment knob — on AWS it is carried by the GovCloud shard (`databricks_gov_shard = "civilian"` → FedRAMP High; `"dod"` → IL5).

# Citations

[1] [Databricks FedRAMP compliance](https://www.databricks.com/trust/compliance/fedramp)
[2] [Databricks on AWS GovCloud](https://docs.databricks.com/aws/en/security/privacy/gov-cloud)
[3] [Azure Databricks FedRAMP High on Azure Government](https://www.databricks.com/company/newsroom/press-releases/azure-databricks-achieves-fedramp-high-authorization-on-microsoft-azure-government-mag)
[4] [Azure Databricks feature region support (UC/SQL not in gov regions)](https://learn.microsoft.com/en-us/azure/databricks/resources/feature-region-support)
