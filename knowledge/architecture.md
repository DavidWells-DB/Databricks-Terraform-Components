---
type: Reference
title: Three-Tier Architecture
description: How Modules, Components, and Blueprints relate in the Databricks Terraform structure.
tags: [architecture, terraform, composition]
timestamp: 2026-07-06T00:00:00Z
---

# Overview

This repository is the **middle tier** of a three-tier Terraform structure:

```
Modules  ──►  Components  ──►  Blueprints
(building     (this repo:       (end-to-end
 blocks)       composed          environment
               patterns)         stacks)
```

- **Modules** — single-purpose building blocks (a VPC, a NAT gateway, a metastore). Published from [Databricks-Terraform-Modules](https://github.com/DavidWells-DB/Databricks-Terraform-Modules) as immutable per-module semver tags (e.g. `dbx-uc-metastore/v0.1.0`).
- **Components** (this repo) — compose modules into a meaningful, reusable pattern. Each component is a self-contained Terraform root with `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md`, and `example.tfvars`.
- **Blueprints** — assemble components into a complete environment for a given workload or customer.

# Conventions

- Components pin module sources to immutable tags (`?ref=<module>/vX.Y.Z`), never `main`. When the modules publish to the Terraform Registry this becomes a `version` constraint.
- Account-level Databricks resources use a provider aliased `databricks.account`; workspace-level resources use `databricks.workspace`.
- Cloud variation is **structural** — a component lives under `networking/<cloud>/…` or `unity-catalog/<cloud>/…`; there is no runtime `cloud` toggle.

# Citations

[1] [Databricks-Terraform-Modules repository](https://github.com/DavidWells-DB/Databricks-Terraform-Modules)
