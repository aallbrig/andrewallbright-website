---
name: wp-ssh
description: Run wp-cli against the production WordPress site safely over SSH via scripts/wp.sh. Use for any inspection or change of the live site (plugins, posts, options, media).
---

# Safe wp-cli over SSH

- Always call `scripts/wp.sh <wp args>`; never run `ssh` directly. Connection settings come from the gitignored `.env`.
- Read-only subcommands (`list`, `get`, `info`, `version`, `status`, `check-update`, `exists`, `search`, `path`) run directly.
- Anything else needs `scripts/wp.sh --confirm ...`, and only after the user approved that specific change in this conversation.
- Refused outright: `db *`, `config *`, `eval`, `eval-file`, `shell`.
- Contact form data (`flamingo_*`, `wpcf7_*`, users' emails) is PII: do not list or print it.
- Prefer `--fields=` and `--format=json` to keep output small. For content, pipe through stdin with `-`.
- Before a risky change, read the current value first and tell the user what will change.
- Useful reads: `post-type list`, `plugin list`, `theme list`, `post list --post_type=portfolio`, `option get blogname`.
