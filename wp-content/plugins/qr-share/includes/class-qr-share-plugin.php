<?php
/**
 * Plugin bootstrap: wires hooks.
 *
 * @package QrShare
 */

declare(strict_types=1);

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Registers the settings screen, shortcode, block and floating button.
 */
final class Qr_Share_Plugin {

	/**
	 * Hook everything up.
	 */
	public function register(): void {
		( new Qr_Share_Settings() )->register();

		add_action( 'init', array( $this, 'register_shortcode_and_block' ) );
		add_action( 'wp_footer', array( $this, 'print_floating_button' ) );
		add_filter( 'plugin_action_links_' . plugin_basename( QR_SHARE_FILE ), array( $this, 'action_links' ) );
	}

	/**
	 * Register the [qr_share] shortcode and the dynamic block.
	 */
	public function register_shortcode_and_block(): void {
		add_shortcode( 'qr_share', array( Qr_Share_Render::class, 'shortcode' ) );

		register_block_type(
			QR_SHARE_DIR . 'blocks/qr-share',
			array( 'render_callback' => array( Qr_Share_Render::class, 'block' ) )
		);
	}

	/**
	 * Print the floating button on front-end pages.
	 */
	public function print_floating_button(): void {
		if ( is_admin() || is_feed() || is_embed() || is_customize_preview() ) {
			return;
		}

		$markup = Qr_Share_Render::floating( Qr_Share_Settings::get(), Qr_Share_Url::current() );
		if ( '' !== $markup ) {
			// Escaped where built in Qr_Share_Render.
			echo $markup; // phpcs:ignore WordPress.Security.EscapeOutput.OutputNotEscaped
		}
	}

	/**
	 * Add a Settings link on the Plugins screen.
	 *
	 * @param array<array-key, string> $links Existing action links.
	 * @return array<array-key, string>
	 */
	public function action_links( array $links ): array {
		$url = admin_url( 'options-general.php?page=' . Qr_Share_Settings::PAGE );
		array_unshift( $links, sprintf( '<a href="%s">%s</a>', esc_url( $url ), esc_html__( 'Settings', 'qr-share' ) ) );
		return $links;
	}
}
