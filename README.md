# Databricks Terraform Components

Composable, opinionated Terraform components for deploying Databricks networking and Unity Catalog foundations across AWS, Azure, and GCP. Each component wires together one or more upstream modules into a deployable unit that maps to a real-world architecture pattern (e.g. "isolated private-link workspace", "shared VPC host project", "regional metastore").

## Architecture

This repository is the **middle tier** of a three-tier Terraform structure:

```
Modules  ──►  Components  ──►  Blueprints
(building     (this repo:       (end-to-end
 blocks)       composed          environment
               patterns)         stacks)
```

- **[Modules](https://github.com/DavidWells-DB/Databricks-Terraform-Modules)** — single-purpose building blocks (a VPC, a NAT gateway, a private endpoint set, a metastore).
- **Components** (this repo) — compose modules into a meaningful, reusable pattern. Each component is a self-contained Terraform root with `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, and a `README.md`.
- **Blueprints** — assemble components into a complete environment for a given workload or customer.

Components source modules directly from the Modules repo via Git, e.g.:

```hcl
module "vpc" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//gcp-account-network-vpc?ref=main"
  # ...
}
```

## Component Catalog

### Networking — AWS

| Component | Description |
|-----------|-------------|
| [`basic`](networking/aws/basic) | Standard Databricks-ready VPC with NAT egress and S3/STS/Kinesis endpoints. |
| [`firewall`](networking/aws/firewall) | VPC with AWS Network Firewall for fine-grained egress filtering. |
| [`exfiltration-protection`](networking/aws/exfiltration-protection) | Hub-spoke with Transit Gateway + Network Firewall for defense-in-depth egress control, optional PrivateLink. |
| [`multi-workspace-privatelink`](networking/aws/multi-workspace-privatelink) | Shared VPC with backend PrivateLink (REST + SCC relay) for multiple workspaces. |
| [`serverless-privatelink`](networking/aws/serverless-privatelink) | NCC + NLB + Endpoint Service so serverless compute reaches customer-managed services via PrivateLink. |

### Networking — Azure

| Component | Description |
|-----------|-------------|
| [`managed-security`](networking/azure/managed-security) | VNet injection with Secure Cluster Connectivity (No Public IP) — the simplest tier. |
| [`hub-spoke-firewall`](networking/azure/hub-spoke-firewall) | Hub-spoke with Azure Firewall egress filtering, public front-end (no Private Link). |
| [`ncc-storage`](networking/azure/ncc-storage) | NCC for serverless compute + VNet injection for classic compute. Each half is independently toggleable (`enable_ncc` / `enable_vnet`) for serverless-only or classic-only deployments. |
| [`hardened-connectivity`](networking/azure/hardened-connectivity) | VNet injection with back-end Private Link; front-end stays public. |
| [`isolated`](networking/azure/isolated) | Full Private Link (front-end, back-end, browser auth) + Azure Firewall in a hub-spoke topology — most restrictive tier. |

### Networking — GCP

| Component | Description |
|-----------|-------------|
| [`byovpc`](networking/gcp/byovpc) | Customer-managed VPC with Cloud NAT — the standard GCP workspace pattern. |
| [`psc-exfiltration-protection`](networking/gcp/psc-exfiltration-protection) | Hub-spoke with Private Service Connect endpoints + deny-all egress to prevent exfiltration. |
| [`shared-vpc`](networking/gcp/shared-vpc) | Shared VPC host project network with Cloud NAT, associating one or more service projects. |

### Unity Catalog

Cloud variation is **structural** — pick the directory for your cloud (`unity-catalog/<cloud>/<component>`), matching the `networking/<cloud>/...` layout. There is no runtime `cloud` toggle.

| Component | Clouds | Description |
|-----------|--------|-------------|
| `metastore-foundation` | [aws](unity-catalog/aws/metastore-foundation) · [azure](unity-catalog/azure/metastore-foundation) · [gcp](unity-catalog/gcp/metastore-foundation) | Regional Unity Catalog metastore foundation — run **once per region** by a platform team. Defaults to a **storageless** metastore (recommended); attach a storage root and workspace assignments only if needed. |
| `domain-catalog` | [aws](unity-catalog/aws/domain-catalog) · [azure](unity-catalog/azure/domain-catalog) · [gcp](unity-catalog/gcp/domain-catalog) | Domain/environment-specific catalog within an existing metastore — run **once per team/env/domain**. Storage credential is created only when the catalog uses external storage. |

## Usage

Each component is a standalone Terraform root. Reference it as a module from a blueprint, or run it directly. Account-level Databricks resources require a provider aliased as `databricks.account`:

```hcl
provider "databricks" {
  alias      = "account"
  host       = "https://accounts.cloud.databricks.com" # or accounts.azuredatabricks.net / accounts.gcp.databricks.com
  account_id = var.databricks_account_id
  # auth via your preferred method (OAuth M2M, Azure CLI, Google credentials, etc.)
}

module "isolated" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Components//networking/azure/isolated?ref=main"

  providers = {
    databricks.account = databricks.account
  }

  # ...component inputs (see the component README)
}
```

See each component's `README.md` for its specific inputs, outputs, and the modules it composes.

## Requirements

- Terraform `>= 1.7`
- `databricks` provider `>= 1.50`
- The relevant cloud provider: `aws`, `azurerm` (`>= 3.70`), or `google` (`>= 5.0`)
- Appropriate account-level credentials for the target cloud

## AWS GovCloud

The AWS networking and Unity Catalog components support **AWS GovCloud** (Civilian / FedRAMP High and DoD / IL5) via the `databricks_gov_shard` and `aws_partition` variables, which switch the Databricks account host and the Databricks-managed IAM identities used in trust policies. GovCloud is AWS-only.

See **[docs/GOVCLOUD.md](docs/GOVCLOUD.md)** for the shard reference table, per-component support, the identity values each shard uses, and a worked example.

## Testing status

Components are validated by real `terraform apply`/`destroy` against live cloud environments. Cloud-native infrastructure (VPCs, subnets, firewalls, private endpoints, NAT, peering) is exercised end-to-end on AWS, Azure, and GCP.

> **Note (GCP):** the Databricks account-registration resources on GCP (`databricks_mws_networks`, PSC-endpoint registration) require a Google-identity-federated account admin to provision and are validated separately from the cloud-native infrastructure.

Each component ships an `example.tfvars` — copy it to `terraform.tfvars` (gitignored) and fill in your values.

## Knowledge bundle (OKF)

[`knowledge/`](knowledge/) is an [Open Knowledge Format](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md) bundle — an agent-consumable knowledge layer with a concept document per component (plus architecture and sovereign-cloud references), cross-linked and indexed. It summarizes and links to the human READMEs; it does not replace them.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for component structure, conventions, and the testing workflow.

## License

See [LICENSE](LICENSE). Copyright Databricks, Inc.
