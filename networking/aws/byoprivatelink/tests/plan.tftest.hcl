variables {
  existing_private_access_settings_id = "existing-pas"
  existing_workspace_vpc_endpoint_id  = "existing-workspace-registration"
  existing_relay_vpc_endpoint_id      = "existing-relay-registration"
}

run "returns_existing_private_connectivity" {
  command = plan

  assert {
    condition     = output.private_access_settings_id == "existing-pas" && output.workspace_vpc_endpoint_id == "existing-workspace-registration" && output.relay_vpc_endpoint_id == "existing-relay-registration"
    error_message = "All existing PrivateLink registration IDs must pass through"
  }
}
