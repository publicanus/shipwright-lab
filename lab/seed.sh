#!/usr/bin/env bash
# Seed a fresh tracker issue from an intent file.
#
# Usage: lab/seed.sh lab/intents/<intent>.md
#
# Title comes from the file's first H1; the body is the rest of the file.
# Every run creates a NEW issue — issues are never reused across lab runs.
set -euo pipefail

intent_file="${1:?usage: lab/seed.sh <intent-file>}"
[ -f "$intent_file" ] || { echo "no such intent file: $intent_file" >&2; exit 1; }

title=$(grep -m1 '^# ' "$intent_file" | sed 's/^# //')
[ -n "$title" ] || { echo "intent file has no H1 title: $intent_file" >&2; exit 1; }

body=$(sed -n '/^# /,$p' "$intent_file" | tail -n +2)

gh issue create --title "$title" --body "$body"
