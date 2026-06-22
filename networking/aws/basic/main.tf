###############################################################################
# Basic Networking Component
# Composes: VPC + Egress Internet (NAT/IGW) + VPC Endpoints (S3/STS/Kinesis)
###############################################################################

module "vpc" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-vpc?ref=main"

  providers = {
    databricks.account = databricks.account
  }

  databricks_account_id = var.databricks_account_id
  resource_prefix       = var.resource_prefix
  network_name          = "${var.resource_prefix}-network"
  vpc_cidr              = var.vpc_cidr
  azs                   = var.availability_zones
  private_subnet_cidrs  = var.private_subnet_cidrs
  public_subnet_cidrs   = var.public_subnet_cidrs
  databricks_gov_shard  = var.databricks_gov_shard
  tags                  = var.tags
}

module "egress_internet" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-egress-internet?ref=main"

  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = values(module.vpc.public_subnet_ids)
  private_route_table_ids = values(module.vpc.private_route_table_ids)
  tags                    = var.tags
}

module "vpc_endpoints" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-vpc-endpoints?ref=main"

  vpc_id                  = module.vpc.vpc_id
  region                  = var.region
  private_subnet_ids      = values(module.vpc.private_subnet_ids)
  security_group_ids      = [module.vpc.security_group_id]
  private_route_table_ids = values(module.vpc.private_route_table_ids)
  databricks_gov_shard    = var.databricks_gov_shard
  tags                    = var.tags
}
