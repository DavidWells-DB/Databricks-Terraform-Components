# Azure existing NAT gateway

References an existing NAT gateway and one of its associated public IPs, then
creates only the selected subnet associations. The gateway, public IP, and
their association remain caller-owned. The caller must ensure routing and any
additional NAT associations are suitable for Databricks.
