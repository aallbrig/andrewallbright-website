<?php
/**
 * Plugin Name:       QR Share
 * Description:       A floating share button that opens a QR code of the current page, with copy-link and native share. Also provides a [qr_share] shortcode and a block.
 * Version:           1.0.1
 * Requires at least: 7.1
 * Requires PHP:      8.3
 * Author:            Andrew Allbright
 * Author URI:        https://andrewallbright.com
 * License:           GPL-2.0-or-later
 * License URI:       https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain:       qr-share
 *
 * @package QrShare
 */

declare(strict_types=1);

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

define( 'QR_SHARE_VERSION', '1.0.1' );
define( 'QR_SHARE_FILE', __FILE__ );
define( 'QR_SHARE_DIR', plugin_dir_path( __FILE__ ) );
define( 'QR_SHARE_URL', plugin_dir_url( __FILE__ ) );

require_once QR_SHARE_DIR . 'includes/class-qr-share-settings.php';
require_once QR_SHARE_DIR . 'includes/class-qr-share-url.php';
require_once QR_SHARE_DIR . 'includes/class-qr-share-render.php';
require_once QR_SHARE_DIR . 'includes/class-qr-share-plugin.php';

( new Qr_Share_Plugin() )->register();
