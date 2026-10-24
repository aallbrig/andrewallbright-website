<?php
/**
 * Plugin Name: Stock themes
 * Description: Dev image only. Registers the stock themes, which live outside the bind-mounted themes folder.
 */

register_theme_directory( WP_CONTENT_DIR . '/themes-stock' );
