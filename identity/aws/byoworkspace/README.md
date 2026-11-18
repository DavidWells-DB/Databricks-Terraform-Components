# AWS existing workspace credentials

References an existing IAM role and creates only the Databricks credentials
registration. It does not create or modify the role, its trust policy, or its
permissions. The role must already meet the Databricks cross-account
requirements for the selected AWS partition and Databricks account.

This is the adopt twin of `aws-account-workspace-credentials`; it exposes the
same outputs consumed by the AWS classic workspace Blueprint.
