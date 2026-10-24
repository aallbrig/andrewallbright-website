<?php
/**
 * Integration tests for URL resolution.
 *
 * @package QrShare
 */

declare(strict_types=1);

/**
 * Qr_Share_Url::current() and ::clean().
 */
final class UrlTest extends WP_UnitTestCase {

	/**
	 * Singular pages use the canonical URL.
	 */
	public function test_singular_uses_canonical(): void {
		$post_id = self::factory()->post->create();
		$this->go_to( get_permalink( $post_id ) );
		$this->assertSame( get_permalink( $post_id ), Qr_Share_Url::current() );
	}

	/**
	 * The front page falls back to the site URL.
	 */
	public function test_home_falls_back_to_site_url(): void {
		$this->go_to( home_url( '/' ) );
		$this->assertSame( home_url( '/' ), Qr_Share_Url::current() );
	}

	/**
	 * A blog index listing posts must not point at the last post of the loop.
	 */
	public function test_posts_index_ignores_last_post_in_loop(): void {
		self::factory()->post->create_many( 3 );
		$this->go_to( home_url( '/' ) );
		the_post(); // phpcs:ignore Generic.PHP.ForbiddenFunctions
		$this->assertSame( home_url( '/' ), Qr_Share_Url::current() );
	}

	/**
	 * Pretty-permalink archives use the request path.
	 */
	public function test_archive_uses_request_url(): void {
		$this->set_permalink_structure( '/%postname%/' );
		create_initial_taxonomies();
		$term_id = self::factory()->category->create( array( 'slug' => 'news' ) );
		$link    = get_category_link( $term_id );
		$this->go_to( $link );
		$this->assertSame( $link, Qr_Share_Url::current() );
		$this->assertStringContainsString( '/category/news/', Qr_Share_Url::current() );
	}

	/**
	 * Plain permalinks keep the query string that identifies the page.
	 */
	public function test_plain_permalink_archive_keeps_query_string(): void {
		$this->set_permalink_structure( '' );
		$term_id = self::factory()->category->create();
		$link    = get_category_link( $term_id );
		$this->go_to( $link );
		$this->assertSame( $link, Qr_Share_Url::current() );
	}

	/**
	 * Search keeps its query.
	 */
	public function test_search_keeps_query(): void {
		$this->set_permalink_structure( '/%postname%/' );
		$this->go_to( home_url( '/?s=qr' ) );
		$this->assertSame( home_url( '/?s=qr' ), Qr_Share_Url::current() );
	}

	/**
	 * Only http(s) URLs pass.
	 */
	public function test_clean_allows_only_web_urls(): void {
		$this->assertSame( 'https://example.org/a', Qr_Share_Url::clean( 'https://example.org/a' ) );
		$this->assertSame( '', Qr_Share_Url::clean( 'javascript:alert(1)' ) );
		$this->assertSame( '', Qr_Share_Url::clean( 'data:text/html;base64,AAAA' ) );
		$this->assertSame( '', Qr_Share_Url::clean( 'ftp://example.org/' ) );
		$this->assertSame( '', Qr_Share_Url::clean( '' ) );
	}
}
