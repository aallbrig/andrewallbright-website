# andrewallbright-website: harness for the live WordPress blog

This **public** repo manages andrewallbright.com (WordPress on DreamHost) over SSH with wp-cli.
It also holds the future home of custom themes and plugins in `wp-content/`.

## Hard rules

- Never commit secrets, hostnames with credentials, DB dumps, `wp-config.php`, `.env`, or SSH keys.
  Pre-commit runs gitleaks and a sensitive-file blocker. Never bypass hooks (`--no-verify`).
- Connection details live only in the gitignored `.env` (see `.env.example`). Never read `~/.ssh`.
- Reach the server only through `scripts/wp.sh`. It refuses `db`, `config`, `eval`, `shell`,
  and any write without `--confirm`. Pass `--confirm` only after the user approved that specific change.
- The contact-form plugins (Flamingo, CF7) hold visitor PII. Never list, print, or copy those records.
- Nothing goes live without human approval of the markdown draft. Create posts as `draft` first.

## Layout

| Path | Purpose |
|------|---------|
| `posts/drafts/`, `posts/published/` | Markdown posts (the editable intermediate artifact) |
| `portfolio/` | Portfolio project write-ups and screenshots |
| `pages/` | Home page as markdown. Read `pages/README.md` before editing it |
| `docs/` | `*_style_guide.md` (voice, plain prose) and `*_tag_audit.md` (categories, tag vocabulary) |
| `scripts/` | `wp.sh` (guarded wp-cli), `wp_post.py` (markdown to WordPress), `wp_media.sh` (image upload), `screenshot.sh` and `screenshot_webgl.sh`, `gh_tech_scan.py`, `check_links.sh`, `install_tools.sh` (composer, actionlint), `dev_env.sh` (WP_DEV_* credentials), `build_plugin.py` (plugin zip) |
| `wp-content/plugins/qr-share/` | QR Share plugin (PHP in `includes/`, JS/CSS in `assets/`, block in `blocks/`, tests in `tests/`) |
| `wp-content/themes` | Custom themes (empty); `wp-content/TODO.md` tracks what is left |
| `docker-compose.yml`, `docker/` | Shared local WordPress 7.1.3 / PHP 8.3 / MariaDB / wp-cli harness and the `test:wp` runner |
| `composer.json`, `phpcs.xml.dist`, `phpstan.neon.dist`, `phpunit.xml.dist`, `package.json`, `eslint.config.js` | PHP and JS toolchain config for everything under `wp-content/` |
| `.claude/agents/blog-author.md` | Interview-and-draft agent |
| `.claude/skills/` | `wp-publish-post`, `wp-ssh`, `portfolio-update` |

## Workflow

- Write a post: use the `blog-author` agent, review the draft in `posts/drafts/`, then run the `wp-publish-post` skill.
- Portfolio, home page and tags: use the `portfolio-update` skill, `pages/README.md` and `docs/*_tag_audit.md`.
- Quality gates: `task lint`, `task test`, `task ci`. Commit only when they pass. `task test:wp` (docker) also runs for plugin changes.
- Plugins: develop against the local site (`task wp:up`, `task wp:down`, `task wp:reset`), ship with `task build:plugin`. WordPress 7.1.x and PHP 8.3 everywhere.
- The local site uses the `WP_DEV_*` values in `.env` (made by `task setup`); never reuse production values there.
- After pushing to `main`, run `gh run list --limit 1` until the CI run shows `success`. Local green does not prove CI green.
  While GitHub Actions is paused (budget used up), nothing runs remotely: report this step as skipped and never claim CI green. `task pr:merge` needs CI, so ask Andrew before merging another way.

## Server facts (verified 2026-10-22)

- WordPress 7.1.3, theme Twenty Twenty-One, plugins: Akismet, Contact Form 7, Flamingo, Google Site Kit, Visual Portfolio.
- The host's default PHP is 8.2 but Contact Form 7 needs 8.3, so `wp.sh` runs wp-cli with `WP_PHP` (PHP 8.3).
- Portfolio items are the `portfolio` post type (Visual Portfolio). Blog posts are the `post` type.

## Gotchas

- The Bash tool runs zsh: unquoted `$var` does not word-split and associative arrays fail. Use `bash -c '...'` for loops over strings.
- A new Claude session in a new folder stops at the trust prompt, and a repo with `.mcp.json` adds an MCP approval prompt. Accept both once by hand.
- Publishing a repo-backed portfolio entry: check `gh repo view --json visibility` first, and never link a private repo.
