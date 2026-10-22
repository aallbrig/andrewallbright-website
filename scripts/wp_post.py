#!/usr/bin/env python3
"""Turn a markdown draft in posts/ into a WordPress post through scripts/wp.sh.

Usage:
  wp_post.py check   FILE            validate frontmatter and print the block HTML
  wp_post.py publish FILE [--dry-run] [--status draft|publish]

A draft is created (or updated when `wp_post_id` is in the frontmatter). Going live
(`--status publish`) is a separate, explicit step the user must approve.
"""

from __future__ import annotations

import argparse
import json
import re
import shlex
import subprocess
import sys
from dataclasses import dataclass, field
from html.parser import HTMLParser
from pathlib import Path

import markdown
import yaml

ROOT = Path(__file__).resolve().parent.parent
WP = ROOT / "scripts" / "wp.sh"
REQUIRED = ("title", "slug", "excerpt")
SLUG_RE = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
FRONTMATTER_RE = re.compile(r"\A---\n(.*?)\n---\n(.*)\Z", re.S)
VOID = {"br", "hr", "img"}
FENCED_RE = re.compile(r"^```.*?^```", re.M | re.S)
EXTERNAL_LINK_RE = re.compile(r'<a href="(https?://[^"]+)"')
LOCAL_IMAGE_RE = re.compile(r"^!\[[^\]]*\]\((?!https?://)[^)]*\)\n?", re.M)


class PostError(ValueError):
    """The draft is not publishable."""


@dataclass
class Post:
    meta: dict[str, object]
    body: str
    categories: list[str] = field(default_factory=list)
    tags: list[str] = field(default_factory=list)


def parse(text: str) -> Post:
    match = FRONTMATTER_RE.match(text)
    if not match:
        raise PostError("missing YAML frontmatter delimited by ---")
    try:
        meta = yaml.safe_load(match.group(1))
    except yaml.YAMLError as err:
        raise PostError(f"frontmatter is not valid YAML (quote values containing ': '): {err}") from err
    if not isinstance(meta, dict):
        raise PostError("frontmatter must be a mapping")
    missing = [key for key in REQUIRED if not meta.get(key)]
    if missing:
        raise PostError(f"frontmatter missing: {', '.join(missing)}")
    if not SLUG_RE.match(str(meta["slug"])):
        raise PostError(f"slug must be lowercase-hyphenated, got {meta['slug']!r}")
    body = match.group(2).strip()
    if not body:
        raise PostError("post body is empty")
    if re.search(r"^# ", FENCED_RE.sub("", body), re.M):
        raise PostError("body must not contain a level-1 heading; the title is the WordPress title")
    return Post(
        meta=meta,
        body=body,
        categories=[str(c) for c in meta.get("categories") or []],
        tags=[str(t) for t in meta.get("tags") or []],
    )


class _TopLevel(HTMLParser):
    """Split an HTML fragment into its top-level elements."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=False)
        self.blocks: list[tuple[str, str]] = []
        self._depth = 0
        self._tag = ""
        self._buf: list[str] = []

    def _emit(self, raw: str) -> None:
        if self._depth > 0 or self._tag:
            self._buf.append(raw)

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        raw = self.get_starttag_text() or ""
        if self._depth == 0:
            self._tag, self._buf = tag, []
        self._buf.append(raw)
        if tag in VOID:
            if self._depth == 0:
                self._finish()
            return
        self._depth += 1

    def handle_startendtag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        """`<hr />`: a void element opens and closes in one event, so do not count a close."""
        self.handle_starttag(tag, attrs)
        if tag not in VOID:
            self.handle_endtag(tag)

    def handle_endtag(self, tag: str) -> None:
        self._buf.append(f"</{tag}>")
        self._depth -= 1
        if self._depth == 0:
            self._finish()

    def handle_data(self, data: str) -> None:
        self._emit(data)

    def handle_comment(self, data: str) -> None:
        """A top-level HTML comment passes through untouched, e.g. a dynamic `wp:latest-posts` block."""
        if self._depth == 0:
            self.blocks.append(("comment", f"<!--{data}-->"))
        else:
            self._buf.append(f"<!--{data}-->")

    def handle_entityref(self, name: str) -> None:
        self._emit(f"&{name};")

    def handle_charref(self, name: str) -> None:
        self._emit(f"&#{name};")

    def _finish(self) -> None:
        self.blocks.append((self._tag, "".join(self._buf)))
        self._tag, self._buf = "", []


def to_blocks(body: str) -> str:
    """Markdown to Gutenberg block markup so the editor shows native blocks."""
    html = markdown.markdown(body, extensions=["fenced_code", "tables", "sane_lists"])
    parser = _TopLevel()
    parser.feed(html)
    parser.close()
    out: list[str] = []
    for tag, raw in parser.blocks:
        if tag == "p" and raw.startswith("<p><img"):
            out.append(f'<!-- wp:image -->\n<figure class="wp-block-image">{raw[3:-4]}</figure>\n<!-- /wp:image -->')
        elif tag == "p":
            out.append(f"<!-- wp:paragraph -->\n{raw}\n<!-- /wp:paragraph -->")
        elif re.fullmatch(r"h[1-6]", tag):
            level = int(tag[1])
            attrs = "" if level == 2 else f' {{"level":{level}}}'
            out.append(f"<!-- wp:heading{attrs} -->\n{raw}\n<!-- /wp:heading -->")
        elif tag in ("ul", "ol"):
            attrs = ' {"ordered":true}' if tag == "ol" else ""
            out.append(f"<!-- wp:list{attrs} -->\n{raw}\n<!-- /wp:list -->")
        elif tag == "pre":
            out.append(f"<!-- wp:code -->\n{raw}\n<!-- /wp:code -->")
        elif tag == "blockquote":
            out.append(f"<!-- wp:quote -->\n{raw}\n<!-- /wp:quote -->")
        elif tag == "hr":
            out.append('<!-- wp:separator -->\n<hr class="wp-block-separator"/>\n<!-- /wp:separator -->')
        elif tag == "comment":
            out.append(raw)
        elif tag == "table":
            raw = EXTERNAL_LINK_RE.sub(r'<a target="_blank" rel="noreferrer noopener" href="\1"', raw)
            out.append(
                '<!-- wp:table {"className":"is-style-stripes"} -->\n'
                f'<figure class="wp-block-table is-style-stripes">{raw}</figure>\n<!-- /wp:table -->'
            )
        else:
            out.append(f"<!-- wp:html -->\n{raw}\n<!-- /wp:html -->")
    return "\n\n".join(out)


def build_commands(post: Post, status: str | None, category_ids: list[int]) -> list[str]:
    """Return the argv for wp.sh as a shell-quoted string; content goes on stdin."""
    post_id = post.meta.get("wp_post_id")
    verb = ["post", "update", str(post_id)] if post_id else ["post", "create", "-", "--porcelain"]
    if post_id:
        verb.append("-")
    args = [
        "--confirm",
        *verb,
        f"--post_title={post.meta['title']}",
        f"--post_name={post.meta['slug']}",
        f"--post_excerpt={post.meta['excerpt']}",
    ]
    # An update keeps the post's current status unless one is requested; a new post defaults to draft.
    if status or not post_id:
        args.append(f"--post_status={status or 'draft'}")
    if category_ids:
        args.append("--post_category=" + ",".join(str(i) for i in category_ids))
    if post.tags:
        args.append("--tags_input=" + ",".join(post.tags))
    return [shlex.join([str(WP), *args])]


def resolve_categories(names: list[str]) -> list[int]:
    if not names:
        return []
    raw = subprocess.run(
        [str(WP), "term", "list", "category", "--fields=term_id,name", "--format=json"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout
    by_name = {t["name"].lower(): int(t["term_id"]) for t in json.loads(raw)}
    unknown = [n for n in names if n.lower() not in by_name]
    if unknown:
        raise PostError(f"unknown categories (create them first): {', '.join(unknown)}")
    return [by_name[n.lower()] for n in names]


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    chk = sub.add_parser("check")
    chk.add_argument("file", type=Path)
    chk.add_argument("--strip-local-images", action="store_true", help="drop images that are not http(s) URLs")
    pub = sub.add_parser("publish")
    pub.add_argument("file", type=Path)
    pub.add_argument("--dry-run", action="store_true")
    pub.add_argument("--strip-local-images", action="store_true", help="drop images that are not http(s) URLs")
    pub.add_argument("--status", choices=["draft", "publish"], default=None)
    args = ap.parse_args(argv)

    try:
        post = parse(args.file.read_text(encoding="utf-8"))
        body = post.body
        if args.strip_local_images:
            body = LOCAL_IMAGE_RE.sub("", body)
        html = to_blocks(body)
        if args.cmd == "check":
            print(html)
            return 0
        ids = [] if args.dry_run else resolve_categories(post.categories)
        (cmd,) = build_commands(post, args.status, ids)
    except PostError as err:
        print(f"error: {err}", file=sys.stderr)
        return 1

    if args.dry_run:
        print(f"[dry-run] would run, with {len(html)} bytes of block HTML on stdin:\n{cmd}")
        return 0
    result = subprocess.run(cmd, shell=True, input=html, text=True, capture_output=True, check=False)
    sys.stderr.write(result.stderr)
    if result.returncode != 0:
        return result.returncode
    print(result.stdout.strip())
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
