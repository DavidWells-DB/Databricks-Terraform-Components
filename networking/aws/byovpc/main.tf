###############################################################################
# BYO-VPC Component (bring-your-own network foundation — create-vs-adopt, Rule 8.4)
#
# The ADOPT twin of networking/aws/basic: consumes an EXISTING customer VPC and
# registers it with the Databricks account API (databricks_mws_networks), creating
# nothing cloud-side except — optionally — the Databricks-required security group
# (self-ingress + open egress, the documented Databricks requirement; pass your own
# security_group_ids to skip creation). Same output contract as `basic`, so the
# blueprint selects create-or-adopt by input presence and downstream wiring is
# unchanged.
#
# Registration model mirrors aws-account-network-vpc v0.3.0 (verified live):
#   - always a "base" registration;
#   - a separate "<name>-privatelink" registration is ADDED when vpc_endpoint_ids
#     are supplied (enable_privatelink is the plan-time switch); the caller repoints
#     the workspace's network_id in place. Nothing is deleted while attached, so the
#     "cannot delete a network attached to a workspace" failure cannot occur.
#
# Intended repin: once the Modules-repo three-piece split lands (a standalone
# registration module), this component should consume it instead of declaring the
# registration inline — tracked in the feedback-integration plan (H5-2). Until then
# this inline declaration is the clean standalone.
###############################################################################

locals {
  # Base name for the registration(s); mirrors the module's cap so the derived
  # "-privatelink" registration fits within Databricks' 100-char name bound.
  network_name = var.network_name != null ? var.network_name : "${var.resource_prefix}-network"

  network_configs = merge(
    { base = local.network_name },
    var.enable_privatelink ? { privatelink = "${local.network_name}-privatelink" } : {}
  )

  active_network = var.enable_privatelink ? "privatelink" : "base"

  security_group_ids = var.existing_security_group_ids != null ? var.existing_security_group_ids : [aws_security_group.databricks[0].id]
}

# The Databricks-required security group, created in the EXISTING VPC when the caller
# does not bring their own. Mirrors aws-account-network-vpc's SG exactly.
resource "aws_security_group" "databricks" {
  count = var.existing_security_group_ids != null ? 0 : 1

  name        = "${var.resource_prefix}-databricks"
  description = "Databricks workspace compute security group - allows all internal VPC traffic and all egress."
  vpc_id      = var.existing_vpc_id

  # Inbound: all traffic from the same security group (node-to-node communication).
  ingress {
    description = "Allow all traffic within the Databricks security group (cluster node to node)."
    from_port   = 0
    to_port    = 0
    protocol    = "-1"
    self        = true
  }

  # Outbound: all egress - Databricks requires unrestricted egress by default.
  egress {
    description = "Allow all egress - Databricks control plane connectivity and package installation."
    from_port   = 0
    to_port    = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
  }

  tags = merge(var.tags, {
    Name = "${var.resource_prefix}-databricks"
  })

  #checkov:skip=CKV_AWS_382: Open egress is a Databricks requirement per https://docs.databricks.com/aws/en/security/network/classic/security-group
  #checkov:skip=CKV2_AWS_5: This SG is attached to Databricks-managed EC2 instances; attachment is outside Terraform's scope here.
}

# Register the EXISTING VPC with the Databricks account API — the component's core
# responsibility. Same retain-old-config pattern as aws-account-network-vpc v0.3.0.
resource "databricks_mws_networks" "this" {
  for_each = local.network_configs

  provider           = databricks.account
  account_id         = var.databricks_account_id
  network_name       = each.value
  security_group_ids = local.security_group_ids
  # Map values (caller-chosen keys -> subnet IDs) keep caller ordering stable; the
  # registration takes a flat list and Databricks does not order subnets.
  subnet_ids = [for _, id in var.existing_private_subnet_ids : id]
  vpc_id     = var.existing_vpc_id

  dynamic "vpc_endpoints" {
    # PrivateLink endpoint IDs belong only to the "privatelink" registration (and only
    # when supplied; enable_privatelink may be set a plan before the endpoint IDs are
    # known — same two-step the create path uses).
    for_each = each.key == "privatelink" && var.vpc_endpoint_ids != null ? [var.vpc_endpoint_ids] : []

    content {
      dataplane_relay = vpc_endpoints.value.relay_id != null ? [vpc_endpoints.value.relay_id] : []
      rest_api        = vpc_endpoints.value.rest_api_id != null ? [vpc_endpoints.value.rest_api_id] : []
    }
  }
}
