---
name: portfolio-update
description: Refresh the portfolio page on andrewallbright.com. Screenshots each project's site, gathers tech stack from GitHub with gh, writes a description in portfolio/, and applies it to the WordPress `portfolio` post type after approval.
---

# Update portfolio items

Portfolio items are the `portfolio` post type (Visual Portfolio plugin). List them with
`scripts/wp.sh post list --post_type=portfolio --fields=ID,post_title,post_name`.

For each project:

1. **Facts.** Find the repo (`gh repo view aallbrig/<repo> --json description,homepageUrl,createdAt,pushedAt,languages`),
   language bytes (`gh api repos/aallbrig/<repo>/languages`), dependencies (`gh api repos/aallbrig/<repo>/contents/<manifest>`
   for `go.mod`, `package.json`, `requirements.txt`, `pyproject.toml`), and the README. Never invent features.
2. **Screenshot.** `scripts/screenshot.sh <url> portfolio/images/<slug>.png` (headless Chrome, 1280x800).
   Look at the image; retake it if it shows a cookie banner, an error, or a blank page.
3. **Write** `portfolio/<slug>.md`: what it is, why it exists, how it works, a **Tech stack** list (language breakdown, key libraries, hosting),
   and links. Audience: engineers interested in his work. Concrete details beat adjectives. Follow the style guide in `docs/`.
4. **Approval.** Show the user the text and screenshots. Do not touch the live site before they approve.
5. **Apply.** Upload the image with `scripts/wp.sh --confirm media import` (after copying it to the server with approval),
   set it as the featured image (`post meta update <ID> _thumbnail_id <attachment>`), and update content with
   `post update <ID> -` from stdin using `python3 scripts/wp_post.py check portfolio/<slug>.md`.
6. Verify the public page with `curl` and re-screenshot `https://andrewallbright.com/portfolio/`.
