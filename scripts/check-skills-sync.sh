#!/usr/bin/env bash
#
# The skills tree is vendored twice: skills/ is what Claude Code, Gemini CLI,
# Cursor, and OpenCode load, and plugins/clor/skills/ is what the .agents
# marketplace installs from (see .agents/plugins/marketplace.json). Nothing
# keeps the two copies in step, so a skill edited in one place silently ships
# stale to half the agents. This check fails when they diverge.
#
# Usage: scripts/check-skills-sync.sh [--fix]
#
#   --fix   copy skills/ over plugins/clor/skills/ instead of reporting

set -euo pipefail

cd "$(dirname "$0")/.."

SRC="skills"
DST="plugins/clor/skills"

if [[ ${1:-} == "--fix" ]]; then
  rm -rf "$DST"
  mkdir -p "$(dirname "$DST")"
  cp -R "$SRC" "$DST"
  echo "synced $SRC -> $DST"
  exit 0
fi

status=0

# Skills present in one tree but not the other.
while read -r name; do
  echo "::error::skill '$name' exists in $SRC but not in $DST"
  status=1
done < <(comm -23 <(ls "$SRC") <(ls "$DST"))

while read -r name; do
  echo "::error::skill '$name' exists in $DST but not in $SRC"
  status=1
done < <(comm -13 <(ls "$SRC") <(ls "$DST"))

# Skills present in both but with different contents.
if ! diff -r -q "$SRC" "$DST" >/dev/null 2>&1; then
  while read -r line; do
    echo "::error::$line"
    status=1
  done < <(diff -r -q "$SRC" "$DST" 2>&1 | grep -v '^Only in ')
fi

if [[ $status -eq 0 ]]; then
  echo "skills trees are in sync ($(ls "$SRC" | wc -l | tr -d ' ') skills)"
else
  echo
  echo "Run 'scripts/check-skills-sync.sh --fix' to copy $SRC over $DST."
fi

exit $status
