###############################################################################
# Serverless PrivateLink Networking Component
# Composes: Network Connectivity Configuration + Serverless PrivateLink
#
# Enables serverless compute (SQL Warehouses, Model Serving, etc.) to
# connect to customer-managed services via NLB + VPC Endpoint Service.
###############################################################################

locals {
  ncc_name                    = var.ncc_name != "" ? var.ncc_name : "${var.resource_prefix}-ncc"
  serverless_privatelink_name = var.serverless_privatelink_name != "" ? var.serverless_privatelink_name : "${var.resource_prefix}-serverless-pl"
}

module "ncc" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-connectivity-config?ref=aws-account-network-connectivity-config/v0.1.0"

  providers = {
    databricks.account = databricks.account
  }

  region = var.region
  name   = local.ncc_name
}

module "serverless_privatelink" {
  source = "github.com/DavidWells-DB/Databricks-Terraform-Modules//aws-account-network-serverless-privatelink?ref=aws-account-network-serverless-privatelink/v0.1.0"

  name                  = local.serverless_privatelink_name
  vpc_id                = var.vpc_id
  subnet_ids            = var.subnet_ids
  target_ip             = var.target_ip
  target_port           = var.target_port
  databricks_account_id = var.databricks_account_id
  aws_partition         = var.aws_partition
  tags                  = var.tags
}
