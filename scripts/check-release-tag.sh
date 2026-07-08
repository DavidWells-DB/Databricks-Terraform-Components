#!/usr/bin/env bash
# Enforces two release-contract rules (RELEASING.md):
#   1. Every tag <component>/vX.Y.Z must have a matching ## [X.Y.Z] entry in
#      that component's CHANGELOG.md — prevents tagging without updating the log.
#   2. The tag must not already exist on the remote — prevents force-moves of
#      published tags (run with --remote to enable the remote check).
#
# Usage:
#   scripts/check-release-tag.sh <component>/vX.Y.Z [--remote]
#
# Exit codes:  0 = all checks passed
#              1 = usage error
#              2 = CHANGELOG entry missing or version mismatch
#              3 = tag already exists on remote (force-move guard)

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <component>/vX.Y.Z [--remote]" >&2
  exit 1
fi

TAG="$1"
CHECK_REMOTE=false
if [[ "${2:-}" == "--remote" ]]; then
  CHECK_REMOTE=true
fi

# Expected format: some/nested/path/vX.Y.Z  (last component is vX.Y.Z)
if [[ ! "$TAG" =~ ^(.+)/v([0-9]+\.[0-9]+\.[0-9]+.*)$ ]]; then
  echo "ERROR: Tag '$TAG' does not match expected format <component>/vX.Y.Z" >&2
  exit 1
fi

COMPONENT="${BASH_REMATCH[1]}"
VERSION="${BASH_REMATCH[2]}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHANGELOG="$REPO_ROOT/$COMPONENT/CHANGELOG.md"

# ── check 1: CHANGELOG entry exists ──────────────────────────────────────────
if [[ ! -f "$CHANGELOG" ]]; then
  echo "ERROR: No CHANGELOG.md found at $CHANGELOG" >&2
  exit 2
fi

if ! grep -qE "^## \[$VERSION\]" "$CHANGELOG"; then
  echo "ERROR: CHANGELOG $CHANGELOG has no entry for version [$VERSION]." >&2
  echo "       Add a '## [$VERSION] - YYYY-MM-DD' section before tagging." >&2
  exit 2
fi

echo "OK: CHANGELOG entry found for [$VERSION] in $COMPONENT/CHANGELOG.md"

# ── check 2: tag not already on remote (force-move guard) ─────────────────────
if [[ "$CHECK_REMOTE" == true ]]; then
  REMOTE_URL=$(git -C "$REPO_ROOT" remote get-url origin 2>/dev/null || echo "")
  if [[ -z "$REMOTE_URL" ]]; then
    echo "WARNING: No remote 'origin' found; skipping remote tag check." >&2
  elif git -C "$REPO_ROOT" ls-remote --tags origin "refs/tags/$TAG" | grep -q .; then
    echo "ERROR: Tag '$TAG' already exists on origin. Tags are immutable — cut a new version instead." >&2
    echo "       See RELEASING.md — Tag immutability section." >&2
    exit 3
  else
    echo "OK: Tag '$TAG' does not yet exist on origin (safe to push)"
  fi
fi

echo "PASS: Release tag '$TAG' is ready to push."
