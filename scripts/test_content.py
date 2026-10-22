"""Mechanical content rules for posts, portfolio entries and pages. Runs in `task ci`."""

from __future__ import annotations

import re
from pathlib import Path

import pytest
import wp_post

ROOT = Path(__file__).resolve().parent.parent
SOURCES = sorted(
    p
    for p in [*(ROOT / "posts").glob("*/*.md"), *(ROOT / "portfolio").glob("*.md"), *(ROOT / "pages").glob("*.md")]
    if p.name != "README.md"
)
POSTS = [p for p in SOURCES if p.parent.parent.name == "posts"]

# Phrases that read as generic AI prose. Say the thing directly instead (see the style guide, "Plain prose").
BANNED_PHRASES = [
    "honest limit",
    "missing piece",
    "think of it as",
    "turned out to be",
    "here is the whole",
    "tapestry",
    "delve",
    "game-changer",
    "ever-evolving",
    "it's worth noting",
]
# Skill-level labels and blog cross-links the home page must not carry (pages/README.md).
HOME_BANNED = re.compile(r"\b(Experienced|Beginner|Comfortable|Proficient|Expert)\b|\bSee:|\bSee \[")


@pytest.mark.parametrize("path", SOURCES, ids=lambda p: str(p.relative_to(ROOT)))
def test_source_parses_and_converts(path: Path) -> None:
    post = wp_post.parse(path.read_text(encoding="utf-8"))
    assert wp_post.to_blocks(wp_post.LOCAL_IMAGE_RE.sub("", post.body))


@pytest.mark.parametrize("path", POSTS, ids=lambda p: p.name)
def test_posts_avoid_banned_phrases(path: Path) -> None:
    text = path.read_text(encoding="utf-8").lower()
    found = [p for p in BANNED_PHRASES if p in text]
    assert not found, f"rewrite these plainly: {found}"


def test_home_page_follows_conventions() -> None:
    text = (ROOT / "pages" / "home.md").read_text(encoding="utf-8")
    assert not HOME_BANNED.search(text), "no skill levels or 'See:' links on the home page"
    rows = [ln for ln in text.splitlines() if ln.startswith("| ") and not ln.startswith(("| ---", "|--"))]
    body_rows = [r for r in rows if not re.match(r"\|\s*(Language|Technology|Editor)\s*\|", r)]
    assert body_rows, "expected technology tables"
    missing = [r.split("|")[1].strip() for r in body_rows if "](http" not in r.split("|")[-2]]
    assert not missing, f"rows without a docs link: {missing}"


def test_portfolio_entries_have_ids_and_images() -> None:
    for path in (ROOT / "portfolio").glob("*.md"):
        meta = wp_post.parse(path.read_text(encoding="utf-8")).meta
        assert meta.get("wp_post_id"), f"{path.name} needs wp_post_id"
        assert (ROOT / "portfolio" / str(meta["image"])).is_file(), f"{path.name} image missing"


def test_private_repos_are_not_linked() -> None:
    for path in (ROOT / "portfolio").glob("*.md"):
        post = wp_post.parse(path.read_text(encoding="utf-8"))
        if post.meta.get("repo_private"):
            assert f"github.com/{post.meta['repo']}" not in post.body, f"{path.name} links a private repo"
