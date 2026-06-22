# AWS Serverless PrivateLink (NCC + NLB + Endpoint Service) — example variables
# Copy to terraform.tfvars (gitignored) and fill in.

databricks_account_id = "00000000-0000-0000-0000-000000000000"
region                = "us-east-1"
resource_prefix       = "my-workspace"

# The VPC/subnets hosting the NLB, and the customer service to expose:
vpc_id      = "vpc-0123456789abcdef0"
subnet_ids  = ["subnet-0a1b2c3d", "subnet-1a2b3c4d"]
target_ip   = "10.0.10.20"
target_port = 5432

# Optional
# ncc_name                    = "my-workspace-ncc"
# serverless_privatelink_name = "my-workspace-serverless-pl"
# aws_partition               = "aws"   # or "aws-us-gov"
# databricks_gov_shard        = null

tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
}
