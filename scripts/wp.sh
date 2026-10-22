#!/usr/bin/env bash
# Run wp-cli on the production host over SSH.
# Connection details come from the SSH alias in WP_SSH_HOST; nothing sensitive lives in this repo.
# Usage: scripts/wp.sh [--confirm] <wp args...>
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -f "$root/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$root/.env"
  set +a
fi

: "${WP_SSH_HOST:?set WP_SSH_HOST (SSH alias) in .env}"
: "${WP_PATH:?set WP_PATH (WordPress root on the server) in .env}"
# The host's default PHP (8.2) cannot load Contact Form 7 (needs >= 8.3), so run wp-cli under a newer PHP.
WP_PHP="${WP_PHP:-/usr/local/php83/bin/php}"

confirm=0
if [[ "${1:-}" == "--confirm" ]]; then
  confirm=1
  shift
fi
(($# > 0)) || { echo "usage: $0 [--confirm] <wp args...>" >&2; exit 2; }

# Judge only the command and subcommand ("post list"), never the arguments, so a post title
# containing "list" cannot unlock a write.
head="${1:-} ${2:-}"
# Nested groups such as "post meta get" are judged on their third word.
[[ "${2:-}" == "meta" ]] && head="$head ${3:-}"

# Never allowed from this harness: DB access/dumps (contact-form PII), config (DB credentials), arbitrary code.
if [[ "$head" =~ ^(db|config|site\ empty|eval|eval-file|shell|ssh) ]]; then
  echo "refused: destructive or arbitrary-code wp command: $head" >&2
  exit 3
fi

# Read-only verbs pass; anything else needs --confirm.
if ((confirm == 0)) && ! [[ "$head" =~ (^|[[:space:]])(list|get|info|version|status|check-update|is-installed|exists|search|path|check|verify-checksums|--info)[[:space:]]*$ ]]; then
  echo "refused: 'wp $head' may write. Re-run with --confirm after the user approves." >&2
  exit 4
fi

printf -v quoted '%q ' "$@"
exec ssh "$WP_SSH_HOST" "cd $(printf '%q' "$WP_PATH") && WP_CLI_PHP=$(printf '%q' "$WP_PHP") wp ${quoted}"
