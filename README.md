# andrewallbright-website

A harness for running [andrewallbright.com](https://andrewallbright.com), a WordPress blog, with AI agents and guardrails.
The repo is public on purpose: it shows how an agent can safely operate a real production site.
Nothing sensitive lives here.

## What is in the box

| Piece | Where | What it does |
|-------|-------|--------------|
| Blog author agent | `.claude/agents/blog-author.md` | Interviews the author, then drafts a post in markdown for human approval |
| Publish skill | `.claude/skills/wp-publish-post/` | Converts an approved markdown draft to WordPress blocks and creates the post with wp-cli |
| SSH/wp-cli skill | `.claude/skills/wp-ssh/` | Rules for touching the live site |
| Portfolio skill | `.claude/skills/portfolio-update/` | Screenshots projects, gathers tech stack with `gh`, updates portfolio entries |
| Style guide | `docs/*_style_guide.md` | The author's voice, so drafts sound like the blog |
| Guarded wp-cli wrapper | `scripts/wp.sh` | The only way the agent reaches the server |
| Markdown to WordPress | `scripts/wp_post.py` | Validates frontmatter and emits Gutenberg block markup |
| Page sources | `pages/` | The home page (technologies grouped by area, each linked to its docs) as editable markdown |
| Taxonomy audit | `docs/*_tag_audit.md` | Category and tag review of every post, with proposed changes |
| QR Share plugin | `wp-content/plugins/qr-share/` | Floating share button, `[qr_share]` shortcode and block, client-side QR code (vendored MIT library, no third-party requests) |
| Local WordPress harness | `docker-compose.yml`, `docker/` | One docker environment (WordPress 7.1.3, PHP 8.3, MariaDB, wp-cli) for every plugin and theme under `wp-content/` |
| Custom themes | `wp-content/themes/` | Empty for now; mounted into the local site when one lands |

## Workflow

```text
idea -> blog-author agent -> posts/drafts/<date>-<slug>.md -> human edits and approves
     -> wp-publish-post: lint, dry run, create draft on WordPress -> human previews -> publish
```

The markdown file is the editable intermediate artifact.
Posts are created as WordPress drafts first, and going live is a separate, explicit step.

## Setup

```bash
task setup    # Python deps, composer and actionlint (checksum-verified, into ~/.local/bin),
              # composer install, npm ci, throwaway WP_DEV_* credentials in .env, git hooks
```

For the live site, copy `.env.example` to `.env` (if you have no `.env` yet) and fill in `WP_SSH_HOST` and `WP_PATH`.
`WP_SSH_HOST` is either an alias from your `~/.ssh/config` or `user@host`. Authentication uses your normal SSH key.
`.env` is gitignored.
`scripts/wp.sh` runs wp-cli under `WP_PHP` because the host's default PHP is older than some plugins require.
The local docker site uses separate `WP_DEV_*` values that `task setup` generates; they are never production values.

## Security model

- **Secrets never reach git.** gitleaks, `detect-private-key` and a sensitive-file blocker (`.env`, `*.sql`, `wp-config.php`, keys) run on every commit.
- **Narrow server access.** `scripts/wp.sh` refuses `db`, `config`, `eval` and `shell`, and requires `--confirm` for anything that can write.
  The project's `.claude/settings.json` denies reading `~/.ssh` and `.env`, and denies direct `ssh`.
- **Human in the loop.** An agent drafts. A person approves. Publishing is a separate step.
- **Visitor data is off limits.** Contact-form records are never listed or copied.

## Quality gates

```bash
task lint     # pre-commit on everything (gitleaks first), phpcs (WordPress standards, warnings fail),
              # PHPStan level max, eslint, prettier, knip, composer audit, npm audit
task test     # pytest, PHPUnit unit suite, JS tests (no docker needed)
task ci       # lint, workflow lint (actionlint), test, build; needs no live services
task test:wp  # PHPUnit unit + integration suites in docker, E_ALL and WP_DEBUG on, coverage threshold
```

The same checks run as pre-commit hooks, so a bad commit is stopped before it exists.
Targets are WordPress 7.1.x and PHP 8.3 everywhere (plugin headers, `composer.json` platform, Docker, CI).

## Local WordPress

```bash
task wp:up      # build and start WordPress, MariaDB; seed the site (admin login is in .env)
task wp:logs    # follow compose logs
task wp:down    # stop, keep data
task wp:reset   # stop and wipe volumes, then start fresh
```

The site is at <http://localhost:8080> (`WP_DEV_PORT`).
Seeded pages: `/qr-shortcode/`, `/qr-shortcode-custom/`, `/qr-block/`, and a sample post `/hello-qr/`.
`wp-content/plugins` and `wp-content/themes` are mounted in, so edits show up immediately.

## Releasing a plugin

GitHub Actions is paused for this repo (the budget is used up), so deploys are manual for now.
The workflows in `.github/workflows/` are written and pass `actionlint`, but have never run remotely.

Manual runbook:

1. `task ci` and `task test:wp` pass locally.
2. `task build:plugin` writes `dist/qr-share-<version>.zip` (no tests or dev files).
3. In WordPress admin, go to Plugins, Add New Plugin, Upload Plugin, and upload the zip. Activate it.

Alternative, only after Andrew approves that specific change: `gh release create v<version> dist/qr-share-<version>.zip`,
then `scripts/wp.sh --confirm plugin install <release-asset-url> --force`.

Automated path, once Actions runs again: bump `Version:` in the plugin header, push a tag `v<version>`,
and `release.yaml` runs `task build:plugin` and attaches the zip to a GitHub Release.
Install it from there with the second route above.

CI runs `task ci` and, in a separate job, `task test:wp` on every push and pull request.
`task pr:merge` waits on CI, so while Actions is paused merge by another route only after asking Andrew.
