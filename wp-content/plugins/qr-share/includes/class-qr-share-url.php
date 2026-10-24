<?php
/**
 * Works out the URL a QR code should point to.
 *
 * @package QrShare
 */

declare(strict_types=1);

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * URL resolution for the page being viewed.
 */
final class Qr_Share_Url {

	/**
	 * The canonical URL of the current singular page, else its permalink-style request URL.
	 *
	 * Outside a normal page request (for example the block editor preview) this is the site URL.
	 */
	public static function current(): string {
		// Only on singular views: elsewhere the global post is just the last item of the loop.
		if ( is_singular() ) {
			$canonical = wp_get_canonical_url();
			if ( is_string( $canonical ) && '' !== $canonical ) {
				return self::clean( $canonical );
			}
		}

		global $wp;
		if ( ! ( $wp instanceof WP ) ) {
			return self::clean( home_url( '/' ) );
		}

		$url = home_url( '/' );
		if ( '' !== $wp->request ) {
			$url = user_trailingslashit( home_url( $wp->request ) );
		}

		// Plain permalinks and search keep the page identity in the query string.
		if ( '' !== $wp->query_string && ( '' === $wp->request || is_search() ) ) {
			$url = add_query_arg( wp_parse_args( $wp->query_string ), $url );
		}

		return self::clean( $url );
	}

	/**
	 * Accept only an http(s) URL; anything else is rejected.
	 *
	 * @param string $url Candidate URL, for example a shortcode attribute.
	 * @return string The escaped URL, or an empty string when it is not a web URL.
	 */
	public static function clean( string $url ): string {
		return esc_url_raw( $url, array( 'http', 'https' ) );
	}
}
