<?php
/**
 * PHPUnit bootstrap. The unit suite runs without WordPress; the integration suite loads the
 * WordPress test library (wp-phpunit) against the plugin.
 *
 * @package QrShare
 */

declare(strict_types=1);

error_reporting( E_ALL ); // phpcs:ignore WordPress.PHP.DiscouragedPHPFunctions.runtime_configuration_error_reporting,WordPress.PHP.DevelopmentFunctions.prevent_path_disclosure_error_reporting

$qr_share_root = dirname( __DIR__, 4 );
require_once $qr_share_root . '/vendor/autoload.php';

// Unit tests never touch WordPress.
if ( getenv( 'QR_SHARE_UNIT_ONLY' ) ) {
	define( 'ABSPATH', '/tmp/' );
	require_once dirname( __DIR__ ) . '/includes/class-qr-share-settings.php';
	return;
}

$qr_share_wp_tests = getenv( 'WP_TESTS_DIR' );
if ( ! is_string( $qr_share_wp_tests ) || '' === $qr_share_wp_tests ) {
	$qr_share_wp_tests = $qr_share_root . '/vendor/wp-phpunit/wp-phpunit';
}

define( 'WP_TESTS_CONFIG_FILE_PATH', __DIR__ . '/wp-tests-config.php' );
define( 'WP_TESTS_PHPUNIT_POLYFILLS_PATH', $qr_share_root . '/vendor/yoast/phpunit-polyfills' );

require_once $qr_share_wp_tests . '/includes/functions.php';

tests_add_filter(
	'muplugins_loaded',
	static function (): void {
		require dirname( __DIR__ ) . '/qr-share.php';
	}
);

require $qr_share_wp_tests . '/includes/bootstrap.php';
