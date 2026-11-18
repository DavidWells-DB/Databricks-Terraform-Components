# AWS existing workspace KMS keys

References existing managed-services and workspace-storage KMS keys and creates
only their Databricks customer-managed-key registrations. Key policies,
rotation, aliases, grants, and deletion remain caller-owned. The caller must
grant the Databricks control plane and cross-account role the permissions
required for their respective use cases.
