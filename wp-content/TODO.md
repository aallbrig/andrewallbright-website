# Custom themes and plugins: TODO

The live site runs stock themes and plugins, so nothing custom exists yet.
`wp-content/themes/` and `wp-content/plugins/` mirror the WordPress directory layout so a
WordPress developer can find things where they expect them.
Before the first custom theme or plugin lands, set up the following.

## Quality gates (pre-commit)

- [ ] PHP formatting: `php-cs-fixer` or `phpcbf`, with the WordPress Coding Standards ruleset
- [ ] PHP linting: `phpcs` with `WordPress`, `WordPress-Extra` and `WordPress-Docs`, plus `php -l`
- [ ] Static analysis: PHPStan (level max) with `szepeviktor/phpstan-wordpress`
- [ ] Warnings as errors: `phpcs --warning-severity=1 --runtime-set ignore_warnings_on_exit 0`, and PHP `error_reporting(E_ALL)` with `WP_DEBUG` on in tests
- [ ] JS and CSS for block themes: `eslint` and `stylelint` through `@wordpress/scripts`
- [ ] Wire all of the above into `.pre-commit-config.yaml` and `task lint` / `task format`

## Tests

- [ ] PHPUnit with `wp-phpunit/wp-phpunit` and the Yoast PHPUnit polyfills
- [ ] Coverage threshold enforced in `task test`
- [ ] `task test:wp` runs the suite inside the docker environment below

## Isolated test environment

- [ ] `docker-compose.yml` with `wordpress`, `mariadb` and a `wpcli` service
- [ ] Mount `wp-content/themes` and `wp-content/plugins` into the container
- [ ] Seed script that installs WordPress, activates the theme or plugin and imports sample content
- [ ] `task wp:up`, `task wp:down` and `task wp:reset`
- [ ] Credentials come from a gitignored `.env`; commit only `.env.example`

## Release

- [ ] Build a zip per theme or plugin in CI
- [ ] Deploy with `wp plugin install <zip>` or `wp theme install <zip>` through `scripts/wp.sh`, never by hand
