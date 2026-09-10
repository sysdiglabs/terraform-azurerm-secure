#!/usr/bin/env bash
#
# Migrates azurerm_monitor_diagnostic_setting.sysdig_org_diagnostic_setting instances
# from count-based addressing ([0], [1], ...) to for_each-based addressing
# (["<subscription-id>"], ...).
#
# Needed because SSPROD-68035 switched this resource from `count` to `for_each` so that
# adding/removing a subscription no longer reorders (and thus destroys/recreates) every
# other subscription's diagnostic setting. Existing organizational installs must run this
# once, against the OLD state, before `terraform apply` with the new module version -
# otherwise Terraform will plan a destroy+recreate of every instance.
#
# Safe to run against installs that never had this resource, or that were already
# migrated (both are no-ops).
#
# Usage (run from the root module directory, after `terraform init`):
#   terraform state pull > pre-migration.tfstate.backup   # keep a backup regardless of backend
#   ./migrate-count-to-for_each.sh            # dry run: prints the state mv commands
#   ./migrate-count-to-for_each.sh --apply    # actually executes them

set -euo pipefail

APPLY=false
if [[ "${1:-}" == "--apply" ]]; then
  APPLY=true
fi

RESOURCE_NAME="azurerm_monitor_diagnostic_setting.sysdig_org_diagnostic_setting"
REGEX="${RESOURCE_NAME//./\\.}\\[[0-9]+\\]\$"

mapfile -t moves < <(terraform show -json | jq -r --arg re "$REGEX" '
  [.. | objects | select(.address? and (.address | test($re)))]
  | .[]
  | select(.values.target_resource_id != null)
  | "\(.address)\t\(.values.target_resource_id)"
')

if [[ ${#moves[@]} -eq 0 ]]; then
  echo "No count-indexed ${RESOURCE_NAME} instances found in state. Nothing to migrate."
  exit 0
fi

for line in "${moves[@]}"; do
  address="${line%%$'\t'*}"
  target_resource_id="${line#*$'\t'}"

  subscription_id="${target_resource_id#*/subscriptions/}"
  subscription_id="${subscription_id%%/*}"
  prefix="${address%\[*}"
  new_address="${prefix}[\"${subscription_id}\"]"

  if $APPLY; then
    terraform state mv -- "$address" "$new_address"
  else
    echo "terraform state mv -- '$address' '$new_address'"
  fi
done

if ! $APPLY; then
  echo
  echo "Dry run only. Re-run with --apply to execute the moves above."
fi
