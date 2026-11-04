#!/usr/bin/env bash
# validate-component.sh <component-dir> — validate one component through a synthetic root.
#
# Components declare configuration_aliases and carry no provider blocks, so a standalone
# `terraform validate` in the component dir fails with "missing provider …". This script
# generates a thin wrapper root in a temp dir (the same mechanism the Blueprints CI uses
# for module-ized roots): the component's required_providers, minimal provider stubs,
# and a module call with the COMPLETE providers map (a partial map does not inherit
# defaults — verified live 2026-11-02), then init + validate against the LOCAL component
# path. No credentials needed; nothing is applied.
#
# Used by CI (unit-tests.yml) and usable locally: scripts/validate-component.sh networking/aws/basic

set -euo pipefail
COMPONENT="${1:?usage: validate-component.sh <component-dir>}"
COMPONENT="$(cd "${COMPONENT}" && pwd)"
WRAP="$(mktemp -d /tmp/component-validate.XXXXXX)"

# 1. required_providers from the component's versions.tf (aliases stripped — the wrapper
#    root owns the provider configs).
REQUIRED_PROVIDERS="$(awk '/required_providers \{/,/^  \}/' "${COMPONENT}/versions.tf" | grep -v 'configuration_aliases')"
[ -n "${REQUIRED_PROVIDERS}" ] || { echo "no required_providers found in ${COMPONENT}" >&2; exit 2; }

# 2. complete providers map + stub blocks for every declared provider.
PROVIDER_MAP="  providers = {"
PROVIDER_BLOCKS=""
for p in $(grep -oE '^    [a-z0-9]+ = \{' "${COMPONENT}/versions.tf" | tr -d ' ={'); do
  if [ "${p}" = "databricks" ]; then
    PROVIDER_MAP="${PROVIDER_MAP}
    databricks.account   = databricks.account
    databricks.workspace = databricks.workspace"
  else
    PROVIDER_MAP="${PROVIDER_MAP}
    ${p} = ${p}"
  fi
  case "${p}" in
    aws)    PROVIDER_BLOCKS="${PROVIDER_BLOCKS}
provider \"aws\" { region = \"us-east-1\" }" ;;
    azurerm) PROVIDER_BLOCKS="${PROVIDER_BLOCKS}
provider \"azurerm\" { features {} }" ;;
    google)  PROVIDER_BLOCKS="${PROVIDER_BLOCKS}
provider \"google\" { project = \"wrapper-validate\" region = \"us-central1\" }" ;;
    azapi)   PROVIDER_BLOCKS="${PROVIDER_BLOCKS}
provider \"azapi\" {}" ;;
    time)    : ;;  # no config arguments
  esac
done
PROVIDER_MAP="${PROVIDER_MAP}
  }"
PROVIDER_BLOCKS="${PROVIDER_BLOCKS}
provider \"databricks\" {
  alias      = \"account\"
  host       = \"https://accounts.cloud.databricks.com\"
  account_id = \"00000000-0000-0000-0000-000000000000\"
}
provider \"databricks\" {
  alias        = \"workspace\"
  host         = \"https://adb-0000000000000000.0.azuredatabricks.net\"
  workspace_id = \"000000000000000\"
}"

cat > "${WRAP}/main.tf" <<EOF
terraform {
  required_version = ">= 1.7"

${REQUIRED_PROVIDERS}
}
${PROVIDER_BLOCKS}

module "component" {
  source = "${COMPONENT}"

${PROVIDER_MAP}
}
EOF

cd "${WRAP}"
terraform init -backend=false -input=false >/dev/null 2>&1
if terraform validate >/dev/null 2>&1; then
  echo "VALID: ${COMPONENT}"
  rm -rf "${WRAP}"
else
  echo "INVALID: ${COMPONENT}" >&2
  terraform validate >&2 || true
  echo "(wrapper kept at ${WRAP} for debugging)" >&2
  exit 1
fi
