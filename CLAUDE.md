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
| `pages/` | WordPress pages kept as markdown (home page with the technologies tables); apply with `scripts/wp_post.py publish` |
| `docs/` | Style guide (`docs/20261022_140002_UTC_style_guide.md`) |
| `scripts/wp.sh`, `scripts/wp_post.py` | Guarded wp-cli wrapper; markdown to WordPress converter |
| `wp-content/themes`, `wp-content/plugins` | Custom theme/plugin code (empty; see `wp-content/TODO.md`) |
| `.claude/agents/blog-author.md` | Interview-and-draft agent |
| `.claude/skills/` | `wp-publish-post`, `wp-ssh`, `portfolio-update` |

## Workflow

- Write a post: use the `blog-author` agent, review the draft in `posts/drafts/`, then run the `wp-publish-post` skill.
- Quality gates: `task lint`, `task test`, `task ci`. Commit only when they pass.

## Server facts (verified 2026-10-22)

- WordPress 7.1.3, theme Twenty Twenty-One, plugins: Akismet, Contact Form 7, Flamingo, Google Site Kit, Visual Portfolio.
- The host's default PHP is 8.2 but Contact Form 7 needs 8.3, so `wp.sh` runs wp-cli with `WP_PHP` (PHP 8.3).
- Portfolio items are the `portfolio` post type (Visual Portfolio). Blog posts are the `post` type.
