mock_provider "google" {
  mock_data "google_compute_network" {
    defaults = {
      name      = "existing-vpc"
      self_link = "https://www.googleapis.com/compute/v1/projects/my-gcp-project/global/networks/existing-vpc"
    }
  }

  mock_data "google_compute_subnetwork" {
    defaults = {
      name          = "existing-subnet"
      region        = "us-central1"
      network       = "https://www.googleapis.com/compute/v1/projects/my-gcp-project/global/networks/existing-vpc"
      self_link     = "https://www.googleapis.com/compute/v1/projects/my-gcp-project/regions/us-central1/subnetworks/existing-subnet"
      ip_cidr_range = "10.0.0.0/16"
    }
  }
}

mock_provider "databricks" {
  alias = "account"
}

variables {
  databricks_account_id         = "44444444-4444-4444-4444-444444444444"
  region                        = "us-central1"
  existing_network_self_link    = "https://www.googleapis.com/compute/v1/projects/my-gcp-project/global/networks/existing-vpc"
  existing_subnetwork_self_link = "https://www.googleapis.com/compute/v1/projects/my-gcp-project/regions/us-central1/subnetworks/existing-subnet"
}

run "references_network_and_creates_registration" {
  command = plan

  variables {
    network_registration_name = "customer-network"
    existing_cloud_nat_id     = "projects/my-gcp-project/regions/us-central1/routers/router/nats/nat"
    existing_cloud_router_id  = "projects/my-gcp-project/regions/us-central1/routers/router"
  }

  assert {
    condition     = databricks_mws_networks.this.network_name == "customer-network" && databricks_mws_networks.this.gcp_network_info[0].vpc_id == "existing-vpc"
    error_message = "The registration must use the existing VPC and explicit registration name"
  }
  assert {
    condition     = databricks_mws_networks.this.gcp_network_info[0].subnet_id == "existing-subnet" && output.network_cidr == "10.0.0.0/16"
    error_message = "The registration and outputs must use the existing subnetwork"
  }
}

run "rejects_subnet_in_another_region" {
  command = plan

  variables {
    existing_subnetwork_self_link = "https://www.googleapis.com/compute/v1/projects/my-gcp-project/regions/us-east1/subnetworks/existing-subnet"
  }

  expect_failures = [var.existing_subnetwork_self_link]
}
