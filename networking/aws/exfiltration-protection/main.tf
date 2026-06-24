###############################################################################
# Exfiltration Protection Networking Component
# Hub-Spoke architecture via Transit Gateway with Network Firewall in hub
# and optional PrivateLink in spoke
#
# Hub VPC: NAT/IGW + Network Firewall (egress filtering)
# Spoke VPC: Databricks workloads + VPC Endpoints + optional PrivateLink
# Transit Gateway: Connects hub and spoke VPCs
###############################################################################

locals {
  firewall_name                = var.firewall_name != "" ? var.firewall_name : "${var.resource_prefix}-hub-firewall"
  private_access_settings_name = var.private_access_settings_name != "" ? var.private_access_settings_name : "${var.resource_prefix}-pas"
  workspace_vpc_endpoint_name  = var.workspace_vpc_endpoint_name != "" ? var.workspace_vpc_endpoint_name : "${var.resource_prefix}-workspace-ep"
  relay_vpc_endpoint_name      = var.relay_vpc_endpoint_name != "" ? var.relay_vpc_endpoint_name : "${var.resource_prefix}-relay-ep"

  hub_firewall_subnets = {
    for idx, cidr in var.hub_firewall_subnet_cidrs :
    "${var.resource_prefix}-hub-firewall-${var.hub_availability_zones[idx]}" => {
      cidr = cidr
      az   = var.hub_availability_zones[idx]
    }
  }
}

###############################################################################
# Hub VPC - Egress/Firewall VPC (no Databricks registration needed)
###############################################################################

resource "aws_vpc" "hub" {
  cidr_block           = var.hub_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.resource_prefix}-hub"
  })
}

resource "aws_subnet" "hub_public" {
  for_each = {
    for idx, cidr in var.hub_public_subnet_cidrs :
    "${var.resource_prefix}-hub-public-${var.hub_availability_zones[idx]}" => {
      cidr = cidr
      az   = var.hub_availability_zones[idx]
    }
  }

  vpc_id                  = aws_vpc.hub.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = each.key
  })
}

resource "aws_subnet" "hub_private" {
  for_each = {
    for idx, cidr in var.hub_private_subnet_cidrs :
    "${var.resource_prefix}-hub-private-${var.hub_availability_zones[idx]}" => {
      cidr = cidr
      az   = var.hub_availability_zones[idx]
    }
  }

  vpc_id            = aws_vpc.hub.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name = each.key
  })
}

resource "aws_subnet" "hub_firewall" {
  for_each = local.hub_firewall_subnets

  vpc_id            = aws_vpc.hub.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name = each.key
  })
}

resource "aws_route_table" "hub_private" {
  for_each = aws_subnet.hub_private

  vpc_id = aws_vpc.hub.id

  tags = merge(var.tags, {
    Name = "${each.key}-rt"
  })
}

resource "aws_route_table_association" "hub_private" {
  for_each = aws_subnet.hub_private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.hub_private[each.key].id
}

resource "aws_route_table" "hub_firewall" {
  for_each = aws_subnet.hub_firewall

  vpc_id = aws_vpc.hub.id

  tags = merge(var.tags, {
    Name = "${each.key}-rt"
  })
}

resource "aws_route_table_association" "hub_firewall" {
  for_each = aws_subnet.hub_firewall

  subnet_id      = each.value.id
  route_table_id = aws_route_table.hub_firewall[each.key].id
}

# NAT/IGW — routes go to firewall subnets (not hub private)
# Traffic flow: spoke → TGW → hub private → firewall → NAT → internet
module "hub_egress_internet" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-egress-internet?ref=aws-account-network-egress-internet/v0.1.0"

  vpc_id                  = aws_vpc.hub.id
  public_subnet_ids       = [for s in aws_subnet.hub_public : s.id]
  private_route_table_ids = [for rt in aws_route_table.hub_firewall : rt.id]
  tags                    = var.tags
}

module "hub_firewall" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-firewall?ref=aws-account-network-firewall/v0.1.0"

  vpc_id                    = aws_vpc.hub.id
  firewall_name             = local.firewall_name
  firewall_subnet_ids       = [for s in aws_subnet.hub_firewall : s.id]
  private_route_table_ids   = [for rt in aws_route_table.hub_private : rt.id]
  stateful_rule_group_arns  = var.firewall_stateful_rule_group_arns
  stateless_rule_group_arns = var.firewall_stateless_rule_group_arns
  tags                      = var.tags
}

###############################################################################
# Spoke VPC - Databricks Workspace VPC
###############################################################################

module "spoke_vpc" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-vpc?ref=aws-account-network-vpc/v0.1.0"

  providers = {
    databricks.account = databricks.account
  }

  databricks_account_id  = var.databricks_account_id
  resource_prefix        = "${var.resource_prefix}-spoke"
  network_name           = "${var.resource_prefix}-network"
  vpc_cidr               = var.spoke_vpc_cidr
  azs                    = var.spoke_availability_zones
  private_subnet_cidrs   = var.spoke_private_subnet_cidrs
  privatelink_subnet_cidrs = var.spoke_privatelink_subnet_cidrs
  databricks_gov_shard   = var.databricks_gov_shard
  vpc_endpoint_ids       = var.enable_privatelink ? {
    rest_api_id = module.spoke_privatelink[0].workspace_vpc_endpoint_id
    relay_id    = module.spoke_privatelink[0].relay_vpc_endpoint_id
  } : null
  tags = var.tags
}

module "spoke_vpc_endpoints" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-vpc-endpoints?ref=aws-account-network-vpc-endpoints/v0.1.0"

  vpc_id                  = module.spoke_vpc.vpc_id
  region                  = var.region
  private_subnet_ids      = values(module.spoke_vpc.private_subnet_ids)
  security_group_ids      = [module.spoke_vpc.security_group_id]
  private_route_table_ids = values(module.spoke_vpc.private_route_table_ids)
  databricks_gov_shard    = var.databricks_gov_shard
  tags                    = var.tags
}

module "spoke_privatelink" {
  count  = var.enable_privatelink ? 1 : 0
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-privatelink-endpoints?ref=aws-account-network-privatelink-endpoints/v0.1.0"

  providers = {
    databricks.account = databricks.account
  }

  vpc_id                             = module.spoke_vpc.vpc_id
  privatelink_subnet_ids             = values(module.spoke_vpc.privatelink_subnet_ids)
  region                             = var.region
  private_access_settings_name       = local.private_access_settings_name
  workspace_vpc_endpoint_name        = local.workspace_vpc_endpoint_name
  relay_vpc_endpoint_name            = local.relay_vpc_endpoint_name
  security_group_name                = "${var.resource_prefix}-spoke-privatelink-sg"
  security_group_ingress_cidr_blocks = [var.spoke_vpc_cidr]
  databricks_gov_shard               = var.databricks_gov_shard
  tags                               = var.tags
}

###############################################################################
# Transit Gateway - Connects Hub and Spoke
###############################################################################

module "transit_gateway" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-transit-gateway?ref=aws-account-network-transit-gateway/v0.1.0"

  resource_prefix = var.resource_prefix
  tgw_asn         = var.tgw_asn

  vpc_attachments = {
    hub = {
      vpc_id     = aws_vpc.hub.id
      subnet_ids = [for s in aws_subnet.hub_private : s.id]
    }
    spoke = {
      vpc_id     = module.spoke_vpc.vpc_id
      subnet_ids = values(module.spoke_vpc.private_subnet_ids)
    }
  }

  tags = var.tags
}
