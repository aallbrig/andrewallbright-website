<?php
/**
 * Unit tests for the pure settings logic.
 *
 * @package QrShare
 */

declare(strict_types=1);

use PHPUnit\Framework\TestCase;

/**
 * Qr_Share_Settings::sanitize() and defaults, without WordPress.
 *
 * @covers Qr_Share_Settings
 */
final class SettingsTest extends TestCase {

	/**
	 * Non-array input falls back to defaults.
	 */
	public function test_non_array_input_returns_defaults(): void {
		$this->assertSame( Qr_Share_Settings::defaults(), Qr_Share_Settings::sanitize( 'nope' ) );
		$this->assertSame( Qr_Share_Settings::defaults(), Qr_Share_Settings::sanitize( null ) );
	}

	/**
	 * An unchecked box (missing key) means disabled.
	 */
	public function test_missing_enabled_means_disabled(): void {
		$result = Qr_Share_Settings::sanitize( array( 'position' => 'top-left' ) );
		$this->assertFalse( $result['enabled'] );
		$this->assertSame( 'top-left', $result['position'] );
	}

	/**
	 * Every allowed position survives; anything else is replaced by the default.
	 */
	public function test_position_is_whitelisted(): void {
		foreach ( Qr_Share_Settings::positions() as $position ) {
			$this->assertSame( $position, Qr_Share_Settings::sanitize( array( 'position' => $position ) )['position'] );
		}
		foreach ( array( 'center', '', '<script>', 5, array( 'top-left' ), null ) as $bad ) {
			$this->assertSame(
				Qr_Share_Settings::DEFAULT_POSITION,
				Qr_Share_Settings::sanitize( array( 'position' => $bad ) )['position']
			);
		}
	}

	/**
	 * Truthy enabled values become a real boolean.
	 */
	public function test_enabled_is_coerced_to_bool(): void {
		$this->assertTrue( Qr_Share_Settings::sanitize( array( 'enabled' => '1' ) )['enabled'] );
		$this->assertFalse( Qr_Share_Settings::sanitize( array( 'enabled' => '' ) )['enabled'] );
	}

	/**
	 * Unknown keys are dropped.
	 */
	public function test_unknown_keys_are_dropped(): void {
		$result = Qr_Share_Settings::sanitize(
			array(
				'enabled' => '1',
				'evil'    => 'x',
			)
		);
		$this->assertSame( array( 'enabled', 'position' ), array_keys( $result ) );
	}
}
