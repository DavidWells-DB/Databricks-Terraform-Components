mock_provider "aws" {}

variables {
  existing_nat_gateway_ids = ["nat-0123456789abcdef0"]
  private_route_table_ids = {
    az1 = "rtb-0123456789abcdef0"
    az2 = "rtb-0abcdef0123456789"
  }
}

run "creates_only_private_routes" {
  command = plan

  assert {
    condition     = length(aws_route.private_nat) == 2 && aws_route.private_nat["az1"].nat_gateway_id == "nat-0123456789abcdef0"
    error_message = "Every selected private route table must route through the existing NAT gateway"
  }
}
