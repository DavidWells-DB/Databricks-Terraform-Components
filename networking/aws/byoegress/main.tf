resource "aws_route" "private_nat" {
  for_each = var.private_route_table_ids

  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = var.existing_nat_gateway_ids[
    index(keys(var.private_route_table_ids), each.key) % length(var.existing_nat_gateway_ids)
  ]
}
