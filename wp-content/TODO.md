# Custom themes and plugins: TODO

`wp-content/themes/` and `wp-content/plugins/` mirror the WordPress directory layout so a
WordPress developer can find things where they expect them.
The shared quality gates, tests, docker environment and plugin zip build are done; see the README.
`wp-content/plugins/qr-share/` is the first plugin.

## Done

- PHP gates: phpcs (`WordPress`, `WordPress-Extra`, `WordPress-Docs`, warnings fail), `php -l`, PHPStan level max with `szepeviktor/phpstan-wordpress`, `composer audit`
- JS gates: eslint (strict), prettier, knip (dead code), `npm audit`
- All of the above in `.pre-commit-config.yaml` and `task lint` / `task format`
- PHPUnit with wp-phpunit and the Yoast polyfills, `E_ALL` and `WP_DEBUG` on, coverage threshold (`task test:wp`)
- `docker-compose.yml` with WordPress, MariaDB and wp-cli, plugin and theme mounts, seed script, `task wp:up` / `wp:down` / `wp:reset`
- Credentials from the gitignored `.env`; only `.env.example` is committed
- `task build:plugin` zip, `release.yaml` workflow that attaches it to a GitHub Release

## Still open

- Block themes: `stylelint` through `@wordpress/scripts` once a theme exists (a theme also needs a build and test story)
- JS coverage threshold: the browser script is tested through jsdom `eval`, which node cannot measure
- Actions workflows have never run remotely (budget exhausted); run them once and fix what they find
- Automated deploy with `scripts/wp.sh --confirm plugin install <zip-url>` after a release; manual upload for now
