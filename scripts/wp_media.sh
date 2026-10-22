#!/usr/bin/env bash
# Upload one local image to the WordPress media library, optionally as a post's featured image.
# The file is streamed over SSH into a throwaway directory, imported with wp-cli, then removed.
# Usage: scripts/wp_media.sh <image.png|jpg|webp> [--post_id=ID --featured_image --title=TEXT --alt=TEXT]
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -f "$root/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$root/.env"
  set +a
fi
: "${WP_SSH_HOST:?set WP_SSH_HOST in .env}"

file="${1:?usage: $0 <image> [wp media import flags]}"
shift
[[ -f "$file" ]] || { echo "no such file: $file" >&2; exit 2; }
case "${file,,}" in
  *.png | *.jpg | *.jpeg | *.webp) ;;
  *) echo "refused: only png, jpg and webp images" >&2; exit 3 ;;
esac

name="$(basename "$file")"
remote_home="$(ssh "$WP_SSH_HOST" 'printf %s "$HOME"')"
remote_dir="wp-harness-upload"
# shellcheck disable=SC2029  # variables are expanded locally on purpose
ssh "$WP_SSH_HOST" "mkdir -p $remote_dir && cat > $remote_dir/$(printf '%q' "$name")" <"$file"
trap 'ssh "$WP_SSH_HOST" "rm -f $remote_dir/$(printf "%q" "$name")"' EXIT

"$root/scripts/wp.sh" --confirm media import "$remote_home/$remote_dir/$name" --porcelain "$@"
