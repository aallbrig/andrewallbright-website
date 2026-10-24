#!/usr/bin/env bash
# Run the whole PHPUnit suite (unit + integration) with coverage and enforce the threshold.
# Runs inside the phpunit container (see docker-compose.yml); the repo is mounted at /workspace.
set -euo pipefail

cd /workspace

# The tests drop and recreate tables, so they get a database of their own.
for _ in $(seq 1 30); do
  mariadb -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" -e 'SELECT 1' >/dev/null 2>&1 && break
  sleep 1
done
mariadb -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" \
  -e "CREATE DATABASE IF NOT EXISTS \`$WP_TESTS_DB_NAME\`"

mkdir -p build
php -d pcov.enabled=1 -d error_reporting=-1 -d display_errors=1 \
  vendor/bin/phpunit --coverage-clover build/clover.xml --coverage-text "$@"

php docker/check-coverage.php build/clover.xml "${COVERAGE_MIN:-80}"
