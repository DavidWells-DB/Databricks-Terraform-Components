# AWS existing workspace root storage

References an existing S3 bucket and creates only the Databricks storage
configuration registration. It does not change bucket versioning, encryption,
public-access settings, policy, retention, or lifecycle rules. Those settings
and the Databricks bucket policy are prerequisites owned by the caller.
