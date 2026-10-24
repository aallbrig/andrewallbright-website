<?php
/**
 * Config for the WordPress test library. Values come from the environment that
 * docker-compose.yml sets; the test database is separate from the dev site's.
 *
 * @package QrShare
 */

define( 'ABSPATH', rtrim( getenv( 'WP_CORE_DIR' ) ? getenv( 'WP_CORE_DIR' ) : '/var/www/html', '/' ) . '/' );

define( 'WP_DEBUG', true );
define( 'WP_DEBUG_DISPLAY', true );
define( 'WP_DEBUG_LOG', false );

define( 'DB_NAME', getenv( 'WP_TESTS_DB_NAME' ) ? getenv( 'WP_TESTS_DB_NAME' ) : 'wordpress_test' );
define( 'DB_USER', getenv( 'WORDPRESS_DB_USER' ) );
define( 'DB_PASSWORD', getenv( 'WORDPRESS_DB_PASSWORD' ) );
define( 'DB_HOST', getenv( 'WORDPRESS_DB_HOST' ) ? getenv( 'WORDPRESS_DB_HOST' ) : 'mariadb' );
define( 'DB_CHARSET', 'utf8mb4' );
define( 'DB_COLLATE', '' );

define( 'WP_TESTS_DOMAIN', 'example.org' );
define( 'WP_TESTS_EMAIL', 'admin@example.org' );
define( 'WP_TESTS_TITLE', 'QR Share Tests' );
define( 'WP_PHP_BINARY', 'php' );
define( 'WPLANG', '' );

$table_prefix = 'wptests_'; // phpcs:ignore WordPress.WP.GlobalVariablesOverride.Prohibited
