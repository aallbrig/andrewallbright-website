<?php
/**
 * Markup for the floating button, the shortcode and the block.
 *
 * @package QrShare
 */

declare(strict_types=1);

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Builds the HTML. All output is escaped here; the script fills in the QR code.
 */
final class Qr_Share_Render {

	public const MIN_SIZE     = 128;
	public const MAX_SIZE     = 512;
	public const DEFAULT_SIZE = 192;

	/**
	 * Clamp a requested QR size in pixels.
	 *
	 * @param mixed $size Raw size from a shortcode or block attribute.
	 */
	public static function clamp_size( mixed $size ): int {
		$size = is_numeric( $size ) ? (int) $size : self::DEFAULT_SIZE;
		return max( self::MIN_SIZE, min( self::MAX_SIZE, $size ) );
	}

	/**
	 * Inline widget: QR code, link field and buttons.
	 *
	 * @param string $url  Web URL to encode.
	 * @param int    $size QR size in pixels.
	 */
	public static function panel( string $url, int $size ): string {
		if ( '' === $url ) {
			return '';
		}

		self::enqueue_assets();

		return sprintf(
			'<div class="qr-share" data-qr-share data-url="%1$s" data-size="%2$d" data-copied="%3$s" data-copy-failed="%4$s" data-code-label="%5$s">'
			. '<div class="qr-share__code" style="--qr-share-size:%2$dpx"></div>'
			. '<input class="qr-share__field" type="text" readonly value="%1$s" aria-label="%6$s" />'
			. '<div class="qr-share__actions">'
			. '<button type="button" class="qr-share__copy" hidden>%7$s</button>'
			. '<button type="button" class="qr-share__native" hidden>%8$s</button>'
			. '</div>'
			. '<p class="qr-share__status" role="status" aria-live="polite"></p>'
			. '</div>',
			esc_url( $url ),
			$size,
			esc_attr__( 'Link copied', 'qr-share' ),
			esc_attr__( 'Press Ctrl+C to copy the link', 'qr-share' ),
			esc_attr__( 'QR code for this page', 'qr-share' ),
			esc_attr__( 'Page link', 'qr-share' ),
			esc_html__( 'Copy link', 'qr-share' ),
			esc_html__( 'Share…', 'qr-share' )
		);
	}

	/**
	 * The floating button and its modal dialog, or an empty string when disabled.
	 *
	 * @param array{enabled: bool, position: string} $settings Sanitised settings.
	 * @param string                                 $url      Web URL to encode.
	 */
	public static function floating( array $settings, string $url ): string {
		if ( ! $settings['enabled'] || '' === $url ) {
			return '';
		}

		$panel = self::panel( $url, 256 );
		if ( '' === $panel ) {
			return '';
		}

		return sprintf(
			'<div class="qr-share-floating qr-share-floating--%1$s" data-qr-share-floating>'
			. '<button type="button" class="qr-share-floating__open" aria-haspopup="dialog" aria-label="%2$s" hidden>%3$s</button>'
			. '<dialog class="qr-share-dialog" aria-labelledby="qr-share-title">'
			. '<div class="qr-share-dialog__body">'
			. '<h2 id="qr-share-title" class="qr-share-dialog__title">%4$s</h2>'
			. '%5$s'
			. '<button type="button" class="qr-share-dialog__close">%6$s</button>'
			. '</div></dialog></div>',
			esc_attr( $settings['position'] ),
			esc_attr__( 'Share this page', 'qr-share' ),
			self::icon(),
			esc_html__( 'Share this page', 'qr-share' ),
			$panel,
			esc_html__( 'Close', 'qr-share' )
		);
	}

	/**
	 * Shortcode handler for [qr_share size="192" url=""].
	 *
	 * @param array<array-key, mixed>|string $atts Raw shortcode attributes.
	 */
	public static function shortcode( array|string $atts ): string {
		$atts = shortcode_atts(
			array(
				'size' => (string) self::DEFAULT_SIZE,
				'url'  => '',
			),
			is_array( $atts ) ? $atts : array(),
			'qr_share'
		);

		$url = is_string( $atts['url'] ) ? Qr_Share_Url::clean( $atts['url'] ) : '';
		if ( '' === $url ) {
			$url = Qr_Share_Url::current();
		}

		return self::panel( $url, self::clamp_size( $atts['size'] ) );
	}

	/**
	 * Dynamic block render callback.
	 *
	 * @param array<string, mixed> $attributes Block attributes.
	 */
	public static function block( array $attributes ): string {
		$panel = self::panel( Qr_Share_Url::current(), self::clamp_size( $attributes['size'] ?? null ) );
		if ( '' === $panel ) {
			return '';
		}
		return sprintf( '<div %s>%s</div>', get_block_wrapper_attributes(), $panel );
	}

	/**
	 * Load the front-end script and style. Safe to call more than once.
	 */
	public static function enqueue_assets(): void {
		$vendor = QR_SHARE_URL . 'assets/vendor/qrcode-generator/';

		wp_enqueue_style( 'qr-share', QR_SHARE_URL . 'assets/css/qr-share.css', array(), QR_SHARE_VERSION );
		wp_enqueue_script( 'qr-share-qrcode', $vendor . 'qrcode.js', array(), '2.0.4', array( 'in_footer' => true ) );
		wp_enqueue_script( 'qr-share-qrcode-utf8', $vendor . 'qrcode_UTF8.js', array( 'qr-share-qrcode' ), '2.0.4', array( 'in_footer' => true ) );
		wp_enqueue_script(
			'qr-share',
			QR_SHARE_URL . 'assets/js/qr-share.js',
			array( 'qr-share-qrcode-utf8' ),
			QR_SHARE_VERSION,
			array(
				'in_footer' => true,
				'strategy'  => 'defer',
			)
		);
	}

	/**
	 * Decorative QR-style icon for the floating button.
	 */
	private static function icon(): string {
		return '<svg aria-hidden="true" focusable="false" viewBox="0 0 24 24" width="24" height="24" fill="currentColor">'
			. '<path d="M3 3h8v8H3zm2 2v4h4V5zm8-2h8v8h-8zm2 2v4h4V5zM3 13h8v8H3zm2 2v4h4v-4zm10-2h2v2h-2zm4 0h2v4h-4v-2h2zm-4 4h2v2h-2zm4 2h2v2h-2z"/></svg>';
	}
}
