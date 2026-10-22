#!/usr/bin/env bash
# Check every external link in pages/ and portfolio/. Needs the network, so it is not part of `task ci`.
# 403 is reported as a warning because several doc sites block scripts. Usage: scripts/check_links.sh
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

grep -ohE '\]\((https?://[^)]+)\)' pages/*.md portfolio/*.md | sed 's/^](//; s/)$//' | sort -u >"${TMPDIR:-/tmp}/links.$$"
trap 'rm -f "${TMPDIR:-/tmp}/links.$$"' EXIT

check() {
  code="$(curl -s -o /dev/null -L -m 25 -A 'Mozilla/5.0' -w '%{http_code}' "$1" || true)"
  [[ "$code" == 200 ]] || echo "$code $1"
}
export -f check

echo "checking $(wc -l <"${TMPDIR:-/tmp}/links.$$") links"
xargs -P 16 -I{} bash -c 'check "{}"' <"${TMPDIR:-/tmp}/links.$$" | sort | tee "${TMPDIR:-/tmp}/bad.$$"
hard="$(grep -cvE '^(403|000) ' "${TMPDIR:-/tmp}/bad.$$" || true)"
rm -f "${TMPDIR:-/tmp}/bad.$$"
echo "non-200 above: 403 and 000 are usually bot blocks or slow hosts; anything else is broken ($hard)"
((hard == 0))
