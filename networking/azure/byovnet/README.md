# Azure existing VNet injection network

References an existing VNet and its host/container subnets. The caller retains
ownership of the VNet, subnets, NSGs, associations, routing, and egress. Before
workspace creation, both Databricks subnets must have the required delegation
and NSG associations; their association IDs are explicit inputs because the
workspace module uses them for ordering as well as validation.
