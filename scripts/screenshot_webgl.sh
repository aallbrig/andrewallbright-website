#!/usr/bin/env bash
# Screenshot a WebGL (Unity) page. Headless Chrome renders these blank, so run headed Chrome with
# software GL on a virtual display, wait for the game to load, and crop off the browser UI.
# Usage: scripts/screenshot_webgl.sh <url> <out.png> [wait-seconds]
set -euo pipefail

url="${1:?usage: $0 <url> <out.png> [wait-seconds]}"
out="${2:?usage: $0 <url> <out.png> [wait-seconds]}"
wait_s="${3:-40}"

if [[ -z "${XVFB_RUNNING:-}" ]]; then
  XVFB_RUNNING=1 exec xvfb-run -a -s "-screen 0 1280x800x24" "$0" "$url" "$out" "$wait_s"
fi

profile="$(mktemp -d)"
google-chrome --no-sandbox --user-data-dir="$profile" --use-gl=angle --use-angle=swiftshader \
  --enable-unsafe-swiftshader --ignore-gpu-blocklist --window-position=0,0 --window-size=1280,800 \
  --no-first-run "$url" >/dev/null 2>&1 &
chrome_pid=$!
trap 'kill "$chrome_pid" 2>/dev/null || true; rm -rf "$profile"' EXIT
sleep "$wait_s"

mkdir -p "$(dirname "$out")"
import -window root -crop 1280x657+0+143 +repage "$out"
echo "$out"
