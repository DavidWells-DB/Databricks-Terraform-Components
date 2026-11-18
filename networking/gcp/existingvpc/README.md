# GCP existing VPC network

References an existing VPC and Databricks node subnetwork, validates their
relationship, and creates only the Databricks network registration. The caller
owns the VPC, subnet, secondary ranges, firewall rules, routes, Cloud NAT, and
their lifecycle. The subnet must have the pod/service secondary ranges and
firewall/egress configuration required by Databricks GCP.
