###############################################################################
# Firewall Networking Component
# Composes: VPC + Egress Internet + VPC Endpoints + AWS Network Firewall
###############################################################################

locals {
  firewall_name = var.firewall_name != "" ? var.firewall_name : "${var.resource_prefix}-firewall"

  firewall_subnets = {
    for idx, cidr in var.firewall_subnet_cidrs :
    "${var.resource_prefix}-firewall-${var.availability_zones[idx]}" => {
      cidr = cidr
      az   = var.availability_zones[idx]
    }
  }
}

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

# Firewall subnets — not supported by the vpc module, created here
resource "aws_subnet" "firewall" {
  for_each = local.firewall_subnets

  vpc_id            = module.vpc.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name = each.key
  })
}

resource "aws_route_table" "firewall" {
  for_each = aws_subnet.firewall

  vpc_id = module.vpc.vpc_id

  tags = merge(var.tags, {
    Name = "${each.key}-rt"
  })
}

resource "aws_route_table_association" "firewall" {
  for_each = aws_subnet.firewall

  subnet_id      = each.value.id
  route_table_id = aws_route_table.firewall[each.key].id
}

# NAT/IGW for internet egress — routes go to firewall subnets (not private)
# Traffic flow: private → firewall → NAT → internet
module "egress_internet" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-egress-internet?ref=main"

  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = values(module.vpc.public_subnet_ids)
  private_route_table_ids = [for rt in aws_route_table.firewall : rt.id]
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

module "firewall" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-firewall?ref=main"

  vpc_id                    = module.vpc.vpc_id
  firewall_name             = local.firewall_name
  firewall_subnet_ids       = [for s in aws_subnet.firewall : s.id]
  private_route_table_ids   = values(module.vpc.private_route_table_ids)
  stateful_rule_group_arns  = var.firewall_stateful_rule_group_arns
  stateless_rule_group_arns = var.firewall_stateless_rule_group_arns
  tags                      = var.tags
}
