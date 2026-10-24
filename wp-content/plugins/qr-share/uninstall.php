<?php
/**
 * Remove the plugin's stored settings on uninstall.
 *
 * @package QrShare
 */

declare(strict_types=1);

if ( ! defined( 'WP_UNINSTALL_PLUGIN' ) ) {
	exit;
}

delete_option( 'qr_share_settings' );
