#!/usr/bin/env bash
#
# Five manifests each carry their own copy of the plugin version, one per
# agent that installs this repo. A release that misses one ships a plugin
# that reports the wrong version to that agent, and nothing catches it at
# review time because the diff looks fine in isolation.
#
# Usage: scripts/check-versions.sh [--set X.Y.Z]
#
#   --set X.Y.Z   write that version into every manifest

set -euo pipefail

cd "$(dirname "$0")/.."

MANIFESTS=(
  .claude-plugin/plugin.json
  .codex-plugin/plugin.json
  .cursor-plugin/plugin.json
  gemini-extension.json
  plugins/clor/.codex-plugin/plugin.json
)

if [[ ${1:-} == "--set" ]]; then
  new="${2:-}"
  if [[ ! $new =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "usage: $0 --set X.Y.Z" >&2
    exit 2
  fi
  # Rewrite the version line in place rather than re-serialising with jq,
  # which would reflow hand-formatted blocks like the one-line
  # "capabilities" array in the Codex manifests.
  for f in "${MANIFESTS[@]}"; do
    python3 - "$f" "$new" <<'PY'
import re, sys

path, new = sys.argv[1], sys.argv[2]
with open(path) as fh:
    text = fh.read()
patched, n = re.subn(r'("version"\s*:\s*")[^"]*(")', rf'\g<1>{new}\g<2>', text, count=1)
if n != 1:
    sys.exit(f"{path}: no version field to set")
with open(path, "w") as fh:
    fh.write(patched)
PY
    echo "$f -> $new"
  done
  exit 0
fi

status=0
declare -A seen

for f in "${MANIFESTS[@]}"; do
  if [[ ! -f $f ]]; then
    echo "::error::manifest $f is missing"
    status=1
    continue
  fi
  if ! jq empty "$f" 2>/dev/null; then
    echo "::error file=$f::not valid JSON"
    status=1
    continue
  fi
  v=$(jq -r '.version // empty' "$f")
  if [[ -z $v ]]; then
    echo "::error file=$f::no version field"
    status=1
    continue
  fi
  if [[ ! $v =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "::error file=$f::version '$v' is not semver"
    status=1
  fi
  seen[$v]+="$f "
done

if [[ ${#seen[@]} -gt 1 ]]; then
  echo "::error::manifest versions disagree"
  for v in "${!seen[@]}"; do
    echo "  $v: ${seen[$v]}"
  done
  status=1
fi

if [[ $status -eq 0 ]]; then
  echo "all ${#MANIFESTS[@]} manifests at ${!seen[*]}"
else
  echo
  echo "Run 'scripts/check-versions.sh --set X.Y.Z' to align them."
fi

exit $status
