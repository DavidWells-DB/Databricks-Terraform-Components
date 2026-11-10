# networking/aws/byovpc

The **adopt** twin of `networking/aws/basic` (create-vs-adopt, BLUEPRINT_SPEC Rule 8.4): consumes an
**existing** customer VPC and registers it with the Databricks account API. Creates nothing
cloud-side except — optionally — the Databricks-required security group. Same output contract as
`basic`, so the blueprint selects create-or-adopt by input presence and downstream wiring is
unchanged.

## When to use

- Your organization mandates an existing, centrally-managed VPC (IPAM, inspection firewalls, Transit Gateway).
- You want the Databricks registration only, without any cloud-side network creation.

## When NOT to use

- You want the framework to create the network foundation — use `networking/aws/basic`.
- Your VPC is serverless-serverless (no classic compute): serverless lanes use NCC, not VPC registration.

## Inputs that matter

- `existing_vpc_id` + `existing_private_subnet_ids` (map, ≥2 subnets across AZs) — the BYO network.
- `existing_security_group_ids` — bring your own SGs (must allow node-to-node within the group and
  control-plane egress); null = the component creates the Databricks-required SG in your VPC.
- `enable_privatelink` + `vpc_endpoint_ids` — the same retain-old-config back-end PrivateLink
  registration pattern as the create path (base retained; workspace repointed in place).
- Echo passthroughs (`existing_public_subnet_ids`, `existing_private_route_table_ids`,
  `existing_privatelink_subnet_ids`) let the egress-internet / vpc-endpoints / privatelink-endpoints
  modules compose against the BYO VPC unchanged.

## Egress is YOURS on this path

The component creates no NAT/IGW — a BYO VPC is expected to carry its own egress. To have the
framework manage NAT on top of your VPC, compose `aws-account-network-egress-internet` with the
echo passthroughs.

## Notes

- Registration names mirror `aws-account-network-vpc` v0.3.0 (`<prefix>-network` +
  `-privatelink` variant), capped per its validation.
- Intended future repin: consume the Modules-repo standalone registration module once the
  three-piece split lands (feedback-integration plan H5-2) instead of declaring the registration inline.

## Example

```hcl
module "network" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Components//networking/aws/byovpc?ref=networking/aws/byovpc/v0.1.0"

  providers = {
    aws                = aws
    databricks.account = databricks.account
  }

  databricks_account_id = var.databricks_account_id
  resource_prefix       = var.resource_prefix

  existing_vpc_id            = "vpc-0abc123"
  existing_private_subnet_ids = {
    az1 = "subnet-0a"
    az2 = "subnet-0b"
  }
}
```
