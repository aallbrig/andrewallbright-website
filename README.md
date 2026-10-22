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
| Custom themes/plugins | `wp-content/` | Empty for now; `wp-content/TODO.md` lists the setup to do first |

## Workflow

```text
idea -> blog-author agent -> posts/drafts/<date>-<slug>.md -> human edits and approves
     -> wp-publish-post: lint, dry run, create draft on WordPress -> human previews -> publish
```

The markdown file is the editable intermediate artifact.
Posts are created as WordPress drafts first, and going live is a separate, explicit step.

## Setup

```bash
task setup                 # installs Python test dependencies and the pre-commit hooks
cp .env.example .env       # then fill in WP_SSH_HOST and WP_PATH
```

`WP_SSH_HOST` is either an alias from your `~/.ssh/config` or `user@host`. Authentication uses your normal SSH key.
`.env` is gitignored.
`scripts/wp.sh` runs wp-cli under `WP_PHP` because the host's default PHP is older than some plugins require.

## Security model

- **Secrets never reach git.** gitleaks, `detect-private-key` and a sensitive-file blocker (`.env`, `*.sql`, `wp-config.php`, keys) run on every commit.
- **Narrow server access.** `scripts/wp.sh` refuses `db`, `config`, `eval` and `shell`, and requires `--confirm` for anything that can write.
  The project's `.claude/settings.json` denies reading `~/.ssh` and `.env`, and denies direct `ssh`.
- **Human in the loop.** An agent drafts. A person approves. Publishing is a separate step.
- **Visitor data is off limits.** Contact-form records are never listed or copied.

## Quality gates

```bash
task lint    # gitleaks, markdownlint, shellcheck, yaml and whitespace checks
task test    # pytest for the markdown converter
task ci      # everything CI runs
```

CI runs the same `task ci` on every push and pull request.
