# GCP existing provisioning identity

References an existing service account and IAM role, creates the project role
binding, and registers the identity as a Databricks account admin. It does not
create or modify the service account, custom role definition, or impersonation
delegates. The role must contain the permissions required by Databricks GCP.
