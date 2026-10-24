#!/bin/sh
# Seed the local dev site: install core, activate plugins, create sample content. Idempotent.
# Runs inside the wpcli container (see docker-compose.yml); wp-cli is on PATH there.
set -eu

cd /var/www/html

i=0
until [ -f wp-config.php ]; do
  i=$((i + 1))
  [ "$i" -lt 60 ] || { echo "wp-config.php never appeared" >&2; exit 1; }
  sleep 1
done

if ! wp core is-installed 2>/dev/null; then
  wp core install \
    --url="$WP_DEV_URL" \
    --title="QR Share Dev" \
    --admin_user="$WP_DEV_ADMIN_USER" \
    --admin_password="$WP_DEV_ADMIN_PASSWORD" \
    --admin_email="$WP_DEV_ADMIN_EMAIL" \
    --skip-email
fi

wp rewrite structure '/%postname%/' --hard

wp plugin activate qr-share

make_page() {
  slug="$1"
  title="$2"
  content="$3"
  if [ -z "$(wp post list --post_type=page --name="$slug" --format=ids)" ]; then
    wp post create --post_type=page --post_status=publish \
      --post_name="$slug" --post_title="$title" --post_content="$content"
  fi
}

make_page qr-shortcode "QR shortcode" '[qr_share]'
make_page qr-shortcode-custom "QR shortcode custom" '[qr_share size="256" url="https://example.org/"]'
make_page qr-block "QR block" '<!-- wp:qr-share/qr-share {"size":256} /-->'

if [ -z "$(wp post list --post_type=post --name=hello-qr --format=ids)" ]; then
  wp post create --post_status=publish --post_name=hello-qr \
    --post_title="Hello QR" --post_content="A sample post with the floating share button."
fi

echo "Seeded: $WP_DEV_URL"
