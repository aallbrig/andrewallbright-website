#!/usr/bin/env bash
# Add throwaway WP_DEV_* credentials for the local docker site to the gitignored .env.
# Generates fresh random values, never copies production ones, and never prints them.
# Existing WP_DEV_* keys are left alone. Usage: scripts/dev_env.sh
set -euo pipefail

cd "$(dirname "$0")/.."
touch .env
chmod 600 .env

rand() { head -c 48 /dev/urandom | base64 | tr -dc 'A-Za-z0-9' | head -c "$1"; }

add() {
  local key="$1" value="$2"
  if ! grep -q "^${key}=" .env; then
    printf '%s=%s\n' "$key" "$value" >>.env
    echo "added $key"
  fi
}

# Start on a fresh line if the file does not end with one.
if [ -s .env ] && [ -n "$(tail -c1 .env)" ]; then
  echo >>.env
fi

add WP_DEV_PORT 8080
add WP_DEV_URL http://localhost:8080
add WP_DEV_DB_NAME wordpress
add WP_DEV_DB_USER wordpress
add WP_DEV_DB_PASSWORD "$(rand 24)"
add WP_DEV_DB_ROOT_PASSWORD "$(rand 24)"
add WP_DEV_ADMIN_USER admin
add WP_DEV_ADMIN_PASSWORD "$(rand 24)"
add WP_DEV_ADMIN_EMAIL admin@example.test
