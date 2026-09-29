###############################################################################
# Basic Networking Component
# Composes: VPC + Egress Internet (NAT/IGW) + VPC Endpoints (S3/STS/Kinesis)
###############################################################################

# Self-deriving network layout so the component plans on required-only inputs.
# Historically availability_zones / *_subnet_cidrs defaulted to [] while the VPC module
# requires >= 2 AZs' worth, so callers had to supply all three (the blueprint worked
# around it locally). The component now derives safe defaults:
#   - AZs: the first az_count available zones in the region;
#   - private subnets: one /20 per AZ (cidrsubnet(vpc_cidr, 4, i));
#   - public subnets:  one /24 per AZ (cidrsubnet(vpc_cidr, 8, 240 + i)),
#     placed high in the range to avoid colliding with the /20 private blocks.
# Explicit inputs always win — passing any of the three overrides the derivation.
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = length(var.availability_zones) > 0 ? var.availability_zones : slice(data.aws_availability_zones.available.names, 0, var.az_count)
  # az_count drives derivation; when AZs are supplied explicitly, follow their count.
  derived_az_count = length(var.availability_zones) > 0 ? length(var.availability_zones) : var.az_count

  private_subnet_cidrs = length(var.private_subnet_cidrs) > 0 ? var.private_subnet_cidrs : [for i in range(local.derived_az_count) : cidrsubnet(var.vpc_cidr, 4, i)]
  public_subnet_cidrs  = length(var.public_subnet_cidrs) > 0 ? var.public_subnet_cidrs : [for i in range(local.derived_az_count) : cidrsubnet(var.vpc_cidr, 8, 240 + i)]
  # PrivateLink subnets are derived from the plan-time boolean `enable_privatelink_subnets`
  # (NOT from vpc_endpoint_ids — those come from endpoints placed IN these subnets, which
  # would create a cycle). /24 per AZ placed high (250+i) to avoid the public (240+i) and
  # /20 private blocks. Explicit privatelink_subnet_cidrs override the derivation.
  privatelink_subnet_cidrs = length(var.privatelink_subnet_cidrs) > 0 ? var.privatelink_subnet_cidrs : (var.enable_privatelink_subnets ? [for i in range(local.derived_az_count) : cidrsubnet(var.vpc_cidr, 8, 250 + i)] : [])
}

module "vpc" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-vpc?ref=aws-account-network-vpc/v0.3.0"

  providers = {
    databricks.account = databricks.account
  }

  databricks_account_id = var.databricks_account_id
  resource_prefix       = var.resource_prefix
  # v0.3.0 module owns the PrivateLink naming and RETAINS the base config (it adds a second
  # "<prefix>-network-privatelink" registration rather than replacing the base one), so the
  # component passes only the static base name plus the plan-time enable_privatelink switch.
  network_name             = "${var.resource_prefix}-network"
  vpc_cidr                 = var.vpc_cidr
  azs                      = local.azs
  private_subnet_cidrs     = local.private_subnet_cidrs
  public_subnet_cidrs      = local.public_subnet_cidrs
  privatelink_subnet_cidrs = local.privatelink_subnet_cidrs
  # Plan-time-known switch for the PrivateLink registration; vpc_endpoint_ids (below) supplies
  # its values but cannot drive the key set because those IDs are known only after apply.
  enable_privatelink   = var.enable_privatelink_subnets
  vpc_endpoint_ids     = var.vpc_endpoint_ids
  databricks_gov_shard = var.databricks_gov_shard
  tags                 = var.tags
}

module "egress_internet" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-egress-internet?ref=aws-account-network-egress-internet/v0.1.0"

  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = values(module.vpc.public_subnet_ids)
  private_route_table_ids = values(module.vpc.private_route_table_ids)
  tags                    = var.tags
}

module "vpc_endpoints" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-vpc-endpoints?ref=aws-account-network-vpc-endpoints/v0.1.0"

  vpc_id                  = module.vpc.vpc_id
  region                  = var.region
  private_subnet_ids      = values(module.vpc.private_subnet_ids)
  security_group_ids      = [module.vpc.security_group_id]
  private_route_table_ids = values(module.vpc.private_route_table_ids)
  databricks_gov_shard    = var.databricks_gov_shard
  tags                    = var.tags
}
