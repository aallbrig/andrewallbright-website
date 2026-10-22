---
name: wp-publish-post
description: Publish an approved markdown post from posts/drafts/ to the live WordPress blog with wp-cli over SSH. Use after the user approves a draft, or to update an already-published post.
---

# Publish a markdown post to WordPress

Input: a path in `posts/drafts/`. Ask which file if it is unclear.

1. **Validate.** `python3 scripts/wp_post.py check <file>` prints the block HTML or an error. Then
   `pre-commit run markdownlint-cli2 --files <file>`. Fix problems with the user; do not silently rewrite their prose.
2. **Confirm approval.** The user must have said the draft is approved in this conversation. If not, stop and ask.
3. **Images.** For each local image in the post, upload with `scripts/wp.sh --confirm media import <path> --porcelain`
   (path must be reachable from the server; copy it with the user's approval first), then replace the markdown path with the returned URL.
4. **Dry run.** `python3 scripts/wp_post.py publish <file> --dry-run`. Show the command to the user.
5. **Create or update the draft.** `python3 scripts/wp_post.py publish <file>`. This is a `draft` unless `wp_post_id` exists, in which case it updates that post.
   Record the printed post ID as `wp_post_id:` in the frontmatter.
6. **Preview.** Give the user the edit link: `https://andrewallbright.com/wp-admin/post.php?post=<ID>&action=edit`.
7. **Go live only on a separate, explicit "publish it".** Then `python3 scripts/wp_post.py publish <file> --status publish`,
   verify with `scripts/wp.sh post get <ID> --fields=post_status,guid`, `curl -sI` the permalink, change `status:` to `published`,
   and move the file to `posts/published/`.
8. Commit the markdown (not secrets) with a one-line message.

Never publish in the same step as creating. Never delete posts. If wp-cli prints a PHP fatal about a plugin, check that `WP_PHP` in `.env` points to PHP 8.3.
