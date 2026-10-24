<?php
/**
 * Plugin settings: storage, sanitising and the admin screen.
 *
 * @package QrShare
 */

declare(strict_types=1);

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Reads, sanitises and renders the plugin settings.
 */
final class Qr_Share_Settings {

	public const OPTION = 'qr_share_settings';
	public const GROUP  = 'qr_share';
	public const PAGE   = 'qr-share';

	public const DEFAULT_POSITION = 'bottom-right';

	/**
	 * Allowed floating button positions.
	 *
	 * @return list<string>
	 */
	public static function positions(): array {
		return array( 'bottom-right', 'bottom-left', 'top-right', 'top-left' );
	}

	/**
	 * Default settings.
	 *
	 * @return array{enabled: bool, position: string}
	 */
	public static function defaults(): array {
		return array(
			'enabled'  => true,
			'position' => self::DEFAULT_POSITION,
		);
	}

	/**
	 * Normalise raw input into a valid settings array. Pure: no WordPress calls.
	 *
	 * @param mixed $input Raw value, usually from the settings form or the database.
	 * @return array{enabled: bool, position: string}
	 */
	public static function sanitize( mixed $input ): array {
		$settings = self::defaults();
		if ( ! is_array( $input ) ) {
			return $settings;
		}

		$settings['enabled'] = ! empty( $input['enabled'] );

		$position = $input['position'] ?? null;
		if ( is_string( $position ) && in_array( $position, self::positions(), true ) ) {
			$settings['position'] = $position;
		}

		return $settings;
	}

	/**
	 * Current settings, falling back to defaults when nothing is saved.
	 *
	 * @return array{enabled: bool, position: string}
	 */
	public static function get(): array {
		$stored = get_option( self::OPTION, false );
		if ( false === $stored ) {
			return self::defaults();
		}
		return self::sanitize( $stored );
	}

	/**
	 * Hook the admin screen and settings registration.
	 */
	public function register(): void {
		add_action( 'admin_menu', array( $this, 'add_page' ) );
		add_action( 'init', array( $this, 'register_option' ) );
		add_action( 'admin_init', array( $this, 'register_settings' ) );
	}

	/**
	 * Add Settings > QR Share.
	 */
	public function add_page(): void {
		add_options_page(
			__( 'QR Share', 'qr-share' ),
			__( 'QR Share', 'qr-share' ),
			'manage_options',
			self::PAGE,
			array( $this, 'render_page' )
		);
	}

	/**
	 * Register the option and its sanitiser. Runs on init, not only in admin, so values saved
	 * through WP-CLI or the REST API are sanitised the same way as the settings form.
	 */
	public function register_option(): void {
		register_setting(
			self::GROUP,
			self::OPTION,
			array(
				'type'              => 'object',
				'sanitize_callback' => array( self::class, 'sanitize' ),
			)
		);
	}

	/**
	 * Register the settings screen sections and fields.
	 */
	public function register_settings(): void {
		add_settings_section( 'qr_share_main', '', '__return_false', self::PAGE );

		add_settings_field(
			'qr_share_enabled',
			__( 'Floating button', 'qr-share' ),
			array( $this, 'render_enabled_field' ),
			self::PAGE,
			'qr_share_main',
			array( 'label_for' => 'qr_share_enabled' )
		);
		add_settings_field(
			'qr_share_position',
			__( 'Position', 'qr-share' ),
			array( $this, 'render_position_field' ),
			self::PAGE,
			'qr_share_main',
			array( 'label_for' => 'qr_share_position' )
		);
	}

	/**
	 * Checkbox for the floating button.
	 */
	public function render_enabled_field(): void {
		$settings = self::get();
		printf(
			'<label><input type="checkbox" id="qr_share_enabled" name="%1$s[enabled]" value="1" %2$s /> %3$s</label>',
			esc_attr( self::OPTION ),
			checked( $settings['enabled'], true, false ),
			esc_html__( 'Show the floating share button on every page', 'qr-share' )
		);
	}

	/**
	 * Select for the button position.
	 */
	public function render_position_field(): void {
		$settings = self::get();
		$labels   = array(
			'bottom-right' => __( 'Bottom right', 'qr-share' ),
			'bottom-left'  => __( 'Bottom left', 'qr-share' ),
			'top-right'    => __( 'Top right', 'qr-share' ),
			'top-left'     => __( 'Top left', 'qr-share' ),
		);

		printf( '<select id="qr_share_position" name="%s[position]">', esc_attr( self::OPTION ) );
		foreach ( $labels as $value => $label ) {
			printf(
				'<option value="%1$s" %2$s>%3$s</option>',
				esc_attr( $value ),
				selected( $settings['position'], $value, false ),
				esc_html( $label )
			);
		}
		echo '</select>';
	}

	/**
	 * The settings screen.
	 */
	public function render_page(): void {
		if ( ! current_user_can( 'manage_options' ) ) {
			return;
		}
		?>
		<div class="wrap">
			<h1><?php echo esc_html__( 'QR Share', 'qr-share' ); ?></h1>
			<form action="options.php" method="post">
				<?php
				settings_fields( self::GROUP );
				do_settings_sections( self::PAGE );
				submit_button();
				?>
			</form>
			<p>
				<?php
				echo wp_kses(
					__( 'Place a code anywhere with the <code>[qr_share]</code> shortcode or the QR Share block.', 'qr-share' ),
					array( 'code' => array() )
				);
				?>
			</p>
		</div>
		<?php
	}
}
