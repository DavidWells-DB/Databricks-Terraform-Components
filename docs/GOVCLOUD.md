# AWS GovCloud Support

Several AWS components in this library support deploying against **Databricks on AWS GovCloud** in addition to commercial AWS. GovCloud is AWS-only — there is no GovCloud equivalent for the Azure or GCP components.

Two variables control GovCloud behavior:

| Variable | Values | Default | Purpose |
|----------|--------|---------|---------|
| `databricks_gov_shard` | `null`, `"civilian"`, `"dod"` | `null` | Selects the Databricks control-plane shard. Drives the Databricks **account host** and the Databricks-managed **IAM role / cross-account IDs** embedded in trust policies. `null` = commercial. |
| `aws_partition` | `"aws"`, `"aws-us-gov"` | `"aws"` | The AWS ARN partition used to construct ARNs. Use `"aws-us-gov"` for both GovCloud shards. |

## The three shards

| Shard | `databricks_gov_shard` | `aws_partition` | Databricks account host | Compliance |
|-------|------------------------|-----------------|-------------------------|------------|
| Commercial | `null` | `aws` | `https://accounts.cloud.databricks.com` | — |
| GovCloud Civilian | `"civilian"` | `aws-us-gov` | `https://accounts.cloud.databricks.us` | FedRAMP High |
| GovCloud DoD | `"dod"` | `aws-us-gov` | `https://accounts-dod.cloud.databricks.mil` | IL5 / DoD |

> `databricks_gov_shard` and `aws_partition` must agree: a non-`null` shard requires `aws_partition = "aws-us-gov"`. The `databricks.account` provider's `host` must match the shard's account host above.

## What the shard actually changes

Setting `databricks_gov_shard` switches the Databricks-managed identities that the modules reference, because GovCloud uses different Databricks-owned AWS accounts than commercial:

**Unity Catalog master role** (the role your storage-credential IAM role trusts):

| Shard | UC master role ARN |
|-------|--------------------|
| Commercial | `arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL` |
| Civilian | `arn:aws-us-gov:iam::044793339203:role/unity-catalog-prod-UCMasterRole-1QRFA8SGY15OJ` |
| DoD | `arn:aws-us-gov:iam::170661010020:role/unity-catalog-prod-UCMasterRole-1DI6DL6ZP26AS` |

**Databricks cross-account ID** (used for workspace credential trust):

| Shard | Databricks AWS account ID |
|-------|---------------------------|
| Commercial | `414351767826` |
| Civilian | `044793339203` |
| DoD | `170661010020` |

These values live in the upstream modules (e.g. `aws-uc-storage-credential`, `aws-account-workspace-credentials`); the components simply pass `databricks_gov_shard` / `aws_partition` through. Source: [Databricks GovCloud docs](https://docs.databricks.com/aws/en/security/privacy/gov-cloud).

## Component support

| Component | `databricks_gov_shard` | `aws_partition` |
|-----------|:----------------------:|:---------------:|
| `networking/aws/basic` | ✅ | — |
| `networking/aws/firewall` | ✅ | — |
| `networking/aws/exfiltration-protection` | ✅ | — |
| `networking/aws/multi-workspace-privatelink` | ✅ | — |
| `networking/aws/serverless-privatelink` | ✅ | ✅ |
| `unity-catalog/metastore-foundation` | ✅ | ✅ |
| `unity-catalog/domain-catalog` | ✅ | ✅ |

The networking VPC components don't expose `aws_partition` directly — the upstream modules derive partition-aware behavior from `databricks_gov_shard`. Components that build storage-credential ARNs (`serverless-privatelink` and the two Unity Catalog components) expose `aws_partition` explicitly.

## Usage example (GovCloud Civilian)

```hcl
provider "aws" {
  region = "us-gov-west-1"
}

provider "databricks" {
  alias      = "account"
  host       = "https://accounts.cloud.databricks.us" # civilian shard
  account_id = var.databricks_account_id
}

module "metastore_foundation" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Components//unity-catalog/metastore-foundation?ref=v1.0.0"

  providers = {
    databricks.account   = databricks.account
    databricks.workspace = databricks.workspace
  }

  cloud                = "aws"
  metastore_name       = "us-gov-west-1-metastore"
  region               = "us-gov-west-1"
  databricks_gov_shard = "civilian"
  aws_partition        = "aws-us-gov"

  # storage_root_url + aws_* inputs only if attaching a metastore storage root
}
```

For DoD (IL5), set `databricks_gov_shard = "dod"` and `host = "https://accounts-dod.cloud.databricks.mil"`.

## Checklist

- [ ] AWS provider `region` is a GovCloud region (`us-gov-west-1` / `us-gov-east-1`).
- [ ] `databricks.account` provider `host` matches the shard (`.databricks.us` for civilian, `.databricks.mil` for DoD).
- [ ] `databricks_gov_shard` set on every GovCloud-aware component in the stack.
- [ ] `aws_partition = "aws-us-gov"` on components that expose it.
- [ ] Your AWS credentials are for the GovCloud partition.
