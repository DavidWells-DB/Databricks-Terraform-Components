variables {
  existing_managed_services_key_id  = "https://existing-vault.vault.azure.net/keys/managed/1234567890abcdef"
  existing_managed_disk_key_id      = "https://existing-vault.vault.azure.net/keys/disk/abcdef1234567890"
  existing_workspace_storage_key_id = "https://existing-vault.vault.azure.net/keys/storage/fedcba0987654321"
}

run "returns_existing_versioned_keys" {
  command = plan

  assert {
    condition     = output.managed_services_key_id == var.existing_managed_services_key_id && output.managed_disk_key_id == var.existing_managed_disk_key_id && output.workspace_storage_key_id == var.existing_workspace_storage_key_id
    error_message = "All three existing versioned key IDs must pass through"
  }
  assert {
    condition     = output.managed_services_key_versionless_id == "https://existing-vault.vault.azure.net/keys/managed"
    error_message = "Versionless outputs must remove only the key version"
  }
}

run "rejects_unversioned_key" {
  command = plan

  variables {
    existing_managed_services_key_id = "https://existing-vault.vault.azure.net/keys/managed"
  }

  expect_failures = [var.existing_managed_services_key_id]
}
