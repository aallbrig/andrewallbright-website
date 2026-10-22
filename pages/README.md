# Pages

`home.md` is the source of the home page: WordPress page ID 8, slug `about`, set as the front page.

## Edit and apply

1. Back up the live content first: `scripts/wp.sh post get 8 --field=post_content > .work/home_backup.html`.
2. Edit `home.md`, then run `task test` (it enforces the conventions below) and `task check:links`.
3. Apply it: `python3 scripts/wp_post.py publish pages/home.md`. An update keeps the page's status.
4. Look at the live page: `scripts/screenshot.sh https://andrewallbright.com/ <out.png>`.

Keep the `<!-- wp:latest-posts ... /-->` comment. It renders the latest-post block.

## Technology tables

- **Grouping.** One table per area (languages, web, cloud, data, AI, and so on), with the columns Technology, Brief, Docs.
- **Brief.** One or two sentences on what the technology is used for. Describe the use, never a skill level.
  Project names appear as plain text, and briefs never link to blog posts.
- **Docs.** Every row links to the official docs or manual, so the page works as a jumping-off point.
  `task check:links` must show only 403 and 000 (bot blocks and slow hosts) as non-200.
- **Voice.** Keep Andrew's own lines where they exist ("Ask me what I would do if an image wasn't building").

## Choosing what to add

- Run `python3 scripts/gh_tech_scan.py` for languages, tooling signals and dependencies across his non-fork repos.
- The latest resume PDF in `~/Downloads` lists professional skills. Read it for technology names only, and never copy it or its contact details into the repo.
- Add a technology only when a repo, a post or the resume shows it.
- Private repos: use only what the project's public site shows, and never link the repo.
