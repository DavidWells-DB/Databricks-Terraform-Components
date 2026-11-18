# Azure existing workspace Key Vault keys

References an existing managed-services, managed-disk, and root-storage key
set. It creates no vault, keys, access policies, private endpoints, or rotation
configuration. All three key URLs must include a version. The caller must grant
the AzureDatabricks service principal Get, WrapKey, and UnwrapKey access.
