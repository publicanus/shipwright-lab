#!/usr/bin/env bash
# environment.setup command for this project: provision the build worktree's
# Salesforce org via shipwright's own sf-env-setup.sh recipe.
#
# Runs from the build worktree (the pipeline's project root). Delegates
# entirely to the plugin script — org strategy comes from shipwright.json,
# the alias is the worktree's directory name, and the resolved alias is
# echoed as the last line of stdout (the pipeline's ENV_HANDLE contract).
set -euo pipefail

# The worktree is a sibling checkout; resolve the main repo root to look up
# which shipwright version this project has bound.
repo_root=$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")

plugin_root=$(jq -r --arg p "$repo_root" '
    .plugins["shipwright@spire"][]
    | select(.scope == "project" and .projectPath == $p)
    | .installPath' "$HOME/.claude/plugins/installed_plugins.json")
[ -n "$plugin_root" ] && [ -d "$plugin_root" ] || {
    echo "org-setup: no shipwright@spire project install found for $repo_root" >&2
    exit 1
}

strategy=$(jq -r '.org_strategy // "none"' shipwright.json)

exec bash "$plugin_root/skills/build/scripts/sf-env-setup.sh" \
    "$PWD" "$strategy" "$(basename "$PWD")" config/project-scratch-def.json
