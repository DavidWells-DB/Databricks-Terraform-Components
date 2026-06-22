# Contributing

Thanks for contributing to the Databricks Terraform Components library. This repo is the **component tier** — it composes upstream [Modules](https://github.com/DavidWells-DB/Databricks-Terraform-Modules) into reusable, deployable patterns consumed by Blueprints.

## Ground rules

- **Never commit secrets.** `.env*`, `gcp-cert.json`, `*.tfvars` (except `example.tfvars`), and Terraform state are gitignored. Double-check `git status` before committing. The Databricks pre-commit/pre-push hooks also scan for secrets.
- **Compose, don't reinvent.** A component should wire together modules and add only the glue (providers, locals, cross-module references) needed for the pattern. If you find yourself writing a generic building block, it probably belongs in the Modules repo.
- **One pattern per component.** Each component maps to a real architecture (e.g. "isolated private-link workspace"). Keep them focused.

## Component structure

Every component is a self-contained Terraform root with this layout:

```
networking/<cloud>/<name>/   (or unity-catalog/<name>/)
├── main.tf          # module composition + glue resources
├── variables.tf     # inputs (required vars have no default)
├── outputs.tf       # outputs downstream blueprints consume
├── versions.tf      # required_version + required_providers (incl. configuration_aliases)
├── example.tfvars   # copyable example inputs (tracked; real tfvars are gitignored)
└── README.md        # purpose, modules composed, inputs, outputs, usage
```

Account-level Databricks resources use a provider aliased as `databricks.account`, declared in `versions.tf` via `configuration_aliases` and passed in by the caller.

## Adding or changing a component

1. Pin module sources to the Modules repo with an explicit `?ref=` (use `main` only during development).
2. Keep variable names and defaults consistent with sibling components (CIDR layouts, `resource_prefix`, `tags`, `databricks_gov_shard`, etc.).
3. Update `variables.tf`, `outputs.tf`, the `README.md` tables, and `example.tfvars` together.
4. Run `terraform fmt` and `terraform validate`.

## Testing

Components are validated with real `terraform apply`/`destroy` against live cloud environments:

1. Drop a `_test_provider.tf` (provider config) and `_test.auto.tfvars` (test inputs) into the component dir — both are gitignored.
2. `terraform init && terraform apply`, verify resources, then `terraform destroy`.
3. Remove the test scaffolding and `.terraform/` before committing.

Cloud-native infrastructure is fully exercised this way. Note that some Databricks account-registration resources on GCP (`databricks_mws_networks`, PSC-endpoint registration) require a Google-identity-federated account admin and are validated separately.

## Commit & PR conventions

- Write clear, imperative commit messages; describe *why*, not just *what*.
- Note any test-driven fixes (what failed, what changed).
- Keep PRs scoped to one component or one cross-cutting concern where practical.
