<?php
/**
 * Integration tests: run inside WordPress via the wp-phpunit test library.
 *
 * @package QrShare
 */

declare(strict_types=1);

/**
 * Hooks, shortcode, block, floating button and settings.
 */
final class PluginTest extends WP_UnitTestCase {

	/**
	 * Reset settings between tests.
	 */
	public function tear_down(): void {
		delete_option( Qr_Share_Settings::OPTION );
		parent::tear_down();
	}

	/**
	 * Whether a method of the given class is attached to a hook.
	 *
	 * @param string $hook  Hook name.
	 * @param string $owner Class whose instance method should be attached.
	 */
	private function plugin_hooked( string $hook, string $owner ): bool {
		global $wp_filter;
		foreach ( $wp_filter[ $hook ]->callbacks ?? array() as $callbacks ) {
			foreach ( $callbacks as $callback ) {
				if ( is_array( $callback['function'] ) && $callback['function'][0] instanceof $owner ) {
					return true;
				}
			}
		}
		return false;
	}

	/**
	 * Plugin boots with the hooks it promises.
	 */
	public function test_hooks_are_registered(): void {
		$this->assertTrue( shortcode_exists( 'qr_share' ) );
		$this->assertTrue( WP_Block_Type_Registry::get_instance()->is_registered( 'qr-share/qr-share' ) );
		$this->assertTrue( $this->plugin_hooked( 'wp_footer', Qr_Share_Plugin::class ) );
		$this->assertTrue( $this->plugin_hooked( 'admin_menu', Qr_Share_Settings::class ) );
		$this->assertTrue( $this->plugin_hooked( 'admin_init', Qr_Share_Settings::class ) );
	}

	/**
	 * The shortcode renders a panel for the current page and defaults the size.
	 */
	public function test_shortcode_renders_panel_for_permalink(): void {
		$post_id = self::factory()->post->create( array( 'post_title' => 'Hello' ) );
		$this->go_to( get_permalink( $post_id ) );

		$html = do_shortcode( '[qr_share]' );

		$this->assertStringContainsString( 'data-qr-share', $html );
		$this->assertStringContainsString( 'data-url="' . esc_url( get_permalink( $post_id ) ) . '"', $html );
		$this->assertStringContainsString( 'data-size="192"', $html );
		$this->assertTrue( wp_script_is( 'qr-share', 'enqueued' ) );
		$this->assertTrue( wp_style_is( 'qr-share', 'enqueued' ) );
	}

	/**
	 * Size is clamped and a custom http(s) url is honoured.
	 */
	public function test_shortcode_clamps_size_and_accepts_url(): void {
		$html = do_shortcode( '[qr_share size="9999" url="https://example.org/x?a=1&b=2"]' );
		$this->assertStringContainsString( 'data-size="512"', $html );
		$this->assertStringContainsString( 'data-url="https://example.org/x?a=1&#038;b=2"', $html );

		$this->assertStringContainsString( 'data-size="128"', do_shortcode( '[qr_share size="1"]' ) );
		$this->assertStringContainsString( 'data-size="192"', do_shortcode( '[qr_share size="abc"]' ) );
	}

	/**
	 * Non-web schemes and attribute-breaking input never reach the markup.
	 */
	public function test_shortcode_rejects_unsafe_urls(): void {
		$this->go_to( home_url( '/' ) );
		$html = do_shortcode( '[qr_share url="javascript:alert(1)"]' );
		$this->assertStringNotContainsString( 'javascript:', $html );
		$this->assertStringContainsString( 'data-url="' . esc_url( home_url( '/' ) ) . '"', $html );

		$html = do_shortcode( '[qr_share url="https://example.org/&quot; onmouseover=&quot;x"]' );
		$this->assertStringNotContainsString( '" onmouseover=', $html );
	}

	/**
	 * The dynamic block renders the same panel.
	 */
	public function test_block_renders(): void {
		$this->go_to( home_url( '/' ) );
		$html = do_blocks( '<!-- wp:qr-share/qr-share {"size":256} /-->' );
		$this->assertStringContainsString( 'data-qr-share', $html );
		$this->assertStringContainsString( 'data-size="256"', $html );
		$this->assertStringContainsString( 'wp-block-qr-share-qr-share', $html );
	}

	/**
	 * The footer hook prints the floating button with the configured position.
	 */
	public function test_floating_button_prints_with_position(): void {
		update_option(
			Qr_Share_Settings::OPTION,
			array(
				'enabled'  => true,
				'position' => 'top-left',
			)
		);
		$this->go_to( home_url( '/' ) );

		ob_start();
		( new Qr_Share_Plugin() )->print_floating_button();
		$html = (string) ob_get_clean();

		$this->assertStringContainsString( 'qr-share-floating--top-left', $html );
		$this->assertStringContainsString( '<dialog', $html );
	}

	/**
	 * Default settings show the button at the bottom right.
	 */
	public function test_floating_button_defaults_on(): void {
		$this->go_to( home_url( '/' ) );
		ob_start();
		( new Qr_Share_Plugin() )->print_floating_button();
		$html = (string) ob_get_clean();
		$this->assertStringContainsString( 'qr-share-floating--bottom-right', $html );
	}

	/**
	 * Disabled setting prints nothing.
	 */
	public function test_floating_button_can_be_disabled(): void {
		update_option( Qr_Share_Settings::OPTION, array( 'position' => 'top-left' ) );
		$this->go_to( home_url( '/' ) );

		ob_start();
		( new Qr_Share_Plugin() )->print_floating_button();
		$html = (string) ob_get_clean();

		$this->assertStringNotContainsString( 'qr-share-floating', $html );
	}

	/**
	 * The button is never printed on feeds.
	 */
	public function test_floating_button_skips_feeds(): void {
		$this->go_to( get_feed_link() );
		ob_start();
		( new Qr_Share_Plugin() )->print_floating_button();
		$html = (string) ob_get_clean();
		$this->assertStringNotContainsString( 'qr-share-floating', $html );
	}

	/**
	 * Stored junk is sanitised on read.
	 */
	public function test_get_sanitises_stored_values(): void {
		update_option(
			Qr_Share_Settings::OPTION,
			array(
				'enabled'  => '1',
				'position' => '<b>x</b>',
			)
		);
		$this->assertSame(
			array(
				'enabled'  => true,
				'position' => 'bottom-right',
			),
			Qr_Share_Settings::get()
		);
	}

	/**
	 * Saving through the Settings API sanitises.
	 */
	public function test_settings_registered_with_sanitize_callback(): void {
		( new Qr_Share_Settings() )->register_settings();
		$registered = get_registered_settings();
		$this->assertArrayHasKey( Qr_Share_Settings::OPTION, $registered );
		$clean = apply_filters(
			'sanitize_option_' . Qr_Share_Settings::OPTION,
			array(
				'enabled'  => '1',
				'position' => 'nope',
			),
			Qr_Share_Settings::OPTION,
			''
		);
		$this->assertSame( 'bottom-right', $clean['position'] );
	}

	/**
	 * Settings page renders for admins only.
	 */
	public function test_settings_page_renders_for_admin_only(): void {
		$settings = new Qr_Share_Settings();
		$settings->register_settings();

		wp_set_current_user( self::factory()->user->create( array( 'role' => 'subscriber' ) ) );
		ob_start();
		$settings->render_page();
		$this->assertSame( '', ob_get_clean() );

		wp_set_current_user( self::factory()->user->create( array( 'role' => 'administrator' ) ) );
		set_current_screen( 'settings_page_qr-share' );
		ob_start();
		$settings->render_page();
		$html = (string) ob_get_clean();
		$this->assertStringContainsString( 'name="qr_share_settings[position]"', $html );
		$this->assertStringContainsString( '[qr_share]', $html );
	}

	/**
	 * The admin menu entry is added for administrators.
	 */
	public function test_add_page_creates_options_page(): void {
		wp_set_current_user( self::factory()->user->create( array( 'role' => 'administrator' ) ) );
		( new Qr_Share_Settings() )->add_page();
		$this->assertNotEmpty( menu_page_url( 'qr-share', false ) );
	}

	/**
	 * The Plugins screen gets a Settings link.
	 */
	public function test_action_links_include_settings(): void {
		$links = ( new Qr_Share_Plugin() )->action_links( array( 'deactivate' ) );
		$this->assertCount( 2, $links );
		$this->assertStringContainsString( 'options-general.php?page=qr-share', $links[0] );
	}

	/**
	 * The settings fields render the saved values.
	 */
	public function test_settings_fields_reflect_saved_values(): void {
		update_option( Qr_Share_Settings::OPTION, array( 'position' => 'top-right' ) );
		$settings = new Qr_Share_Settings();

		ob_start();
		$settings->render_enabled_field();
		$enabled = (string) ob_get_clean();
		$this->assertStringNotContainsString( 'checked', $enabled );

		ob_start();
		$settings->render_position_field();
		$position = (string) ob_get_clean();
		$this->assertMatchesRegularExpression( '/<option value="top-right"\s+selected=\'selected\'/', $position );
		$this->assertSame( 4, substr_count( $position, '<option' ) );
	}

	/**
	 * The button is skipped in admin and in the customizer preview.
	 */
	public function test_floating_button_skips_admin(): void {
		set_current_screen( 'dashboard' );
		ob_start();
		( new Qr_Share_Plugin() )->print_floating_button();
		$html = (string) ob_get_clean();
		set_current_screen( 'front' );
		$this->assertSame( '', $html );
	}

	/**
	 * Uninstalling removes the stored option.
	 */
	public function test_uninstall_deletes_option(): void {
		update_option( Qr_Share_Settings::OPTION, array( 'enabled' => true ) );
		define( 'WP_UNINSTALL_PLUGIN', 'qr-share/qr-share.php' );
		require QR_SHARE_DIR . 'uninstall.php';
		$this->assertFalse( get_option( Qr_Share_Settings::OPTION ) );
	}

	/**
	 * A shortcode with an empty override url and no usable page still renders nothing unsafe.
	 */
	public function test_panel_with_empty_url_renders_nothing(): void {
		$this->assertSame( '', Qr_Share_Render::panel( '', 192 ) );
		$this->assertSame( '', Qr_Share_Render::floating( Qr_Share_Settings::defaults(), '' ) );
	}
}
