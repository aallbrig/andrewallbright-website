"""Unit tests for scripts/wp_post.py (no network, no SSH)."""

from __future__ import annotations

import pytest
import wp_post

GOOD = """---
title: Hello
slug: hello-world
excerpt: A short one.
categories: [Programming]
tags: [go, ai]
---

Opening paragraph with `code`.

## Section

- one
- two

```bash
echo hi
```

![alt text](image.png)
"""


def test_parse_ok() -> None:
    post = wp_post.parse(GOOD)
    assert post.meta["slug"] == "hello-world"
    assert post.tags == ["go", "ai"]
    assert post.categories == ["Programming"]


@pytest.mark.parametrize(
    "text,msg",
    [
        ("no frontmatter", "frontmatter"),
        ("---\ntitle: x\n---\nbody", "missing"),
        ("---\ntitle: x\nslug: Bad Slug\nexcerpt: e\n---\nbody", "slug"),
        ("---\ntitle: x\nslug: ok\nexcerpt: e\n---\n\n", "empty"),
        ("---\ntitle: x\nslug: ok\nexcerpt: e\n---\n# H1\n", "level-1"),
    ],
)
def test_parse_rejects(text: str, msg: str) -> None:
    with pytest.raises(wp_post.PostError, match=msg):
        wp_post.parse(text)


def test_blocks() -> None:
    html = wp_post.to_blocks(wp_post.parse(GOOD).body)
    assert "<!-- wp:paragraph -->" in html
    assert "<!-- wp:heading -->" in html
    assert "<!-- wp:list -->" in html
    assert "<!-- wp:code -->" in html
    assert "<!-- wp:image -->" in html
    assert html.count("<!-- wp:") == html.count("<!-- /wp:")


def test_create_command_is_draft_and_confirmed() -> None:
    (cmd,) = wp_post.build_commands(wp_post.parse(GOOD), "draft", [3])
    assert "--confirm post create - --porcelain" in cmd
    assert "--post_status=draft" in cmd
    assert "--post_category=3" in cmd
    assert "--tags_input=go,ai" in cmd


def test_update_command_when_id_present() -> None:
    post = wp_post.parse(GOOD.replace("slug: hello-world", "slug: hello-world\nwp_post_id: 42"))
    (cmd,) = wp_post.build_commands(post, "draft", [])
    assert "post update 42 -" in cmd


def test_parse_reports_bad_yaml() -> None:
    with pytest.raises(wp_post.PostError, match="valid YAML"):
        wp_post.parse("---\ntitle: Routine Mark: track\nslug: x\nexcerpt: e\n---\nbody")


def test_update_does_not_change_status_by_default() -> None:
    post = wp_post.parse(GOOD.replace("slug: hello-world", "slug: hello-world\nwp_post_id: 42"))
    (cmd,) = wp_post.build_commands(post, None, [])
    assert "--post_status" not in cmd
    (cmd,) = wp_post.build_commands(post, "publish", [])
    assert "--post_status=publish" in cmd


def test_create_defaults_to_draft() -> None:
    (cmd,) = wp_post.build_commands(wp_post.parse(GOOD), None, [])
    assert "--post_status=draft" in cmd


def test_comment_block_passes_through_and_tables_are_striped() -> None:
    body = '<!-- wp:latest-posts {"postsToShow":1} /-->\n\n| A | B |\n|---|---|\n| x | [d](https://example.com) |\n'
    html = wp_post.to_blocks(body)
    assert '<!-- wp:latest-posts {"postsToShow":1} /-->' in html
    assert "is-style-stripes" in html
    assert 'target="_blank" rel="noreferrer noopener" href="https://example.com"' in html


def test_self_closing_hr_does_not_break_following_blocks() -> None:
    html = wp_post.to_blocks("Intro.\n\n---\n\n## Heading\n\n| A |\n|---|\n| x |\n")
    assert "<!-- wp:separator -->" in html
    assert "<!-- wp:heading -->" in html
    assert "<!-- wp:table" in html
    assert "<!-- wp:html -->" not in html


def test_hash_comment_inside_code_fence_is_not_a_heading() -> None:
    text = "---\ntitle: x\nslug: ok\nexcerpt: e\n---\nIntro.\n\n```bash\n# a shell comment\necho hi\n```\n"
    assert wp_post.parse(text).body.startswith("Intro.")
