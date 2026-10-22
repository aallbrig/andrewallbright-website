#!/usr/bin/env bash
# Take a 1280x800 screenshot of a URL with headless Chrome.
# Usage: scripts/screenshot.sh <url> <out.png>
set -euo pipefail

url="${1:?usage: $0 <url> <out.png>}"
out="${2:?usage: $0 <url> <out.png>}"
chrome="${CHROME:-google-chrome}"

mkdir -p "$(dirname "$out")"
"$chrome" --headless=new --no-sandbox --disable-gpu --hide-scrollbars \
  --window-size=1280,800 --virtual-time-budget=8000 \
  --screenshot="$out" "$url" >/dev/null 2>&1
test -s "$out" && echo "$out"
