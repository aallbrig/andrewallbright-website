#!/usr/bin/env python3
"""Build dist/<slug>-<version>.zip for a plugin under wp-content/plugins/, without tests or dev files.

Usage: scripts/build_plugin.py [slug]   (default: qr-share)
"""

from __future__ import annotations

import re
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PLUGINS = ROOT / "wp-content" / "plugins"

EXCLUDED_DIRS = {"tests", "node_modules", "vendor-dev", ".git", ".github", "coverage", "build"}
EXCLUDED_NAMES = {
    ".DS_Store",
    ".editorconfig",
    ".gitignore",
    ".phpcs-cache",
    "composer.json",
    "composer.lock",
    "package.json",
    "package-lock.json",
    "phpcs.xml.dist",
    "phpstan.neon.dist",
    "phpunit.xml.dist",
}
EXCLUDED_SUFFIXES = {".map", ".log", ".md.bak"}
FIXED_TIME = (2026, 1, 1, 0, 0, 0)


def plugin_version(plugin_dir: Path) -> str:
    """Read `Version:` from the main plugin file header."""
    main = plugin_dir / f"{plugin_dir.name}.php"
    match = re.search(r"^[ \t/*#@]*Version:\s*(\S+)", main.read_text(), re.MULTILINE)
    if not match:
        raise SystemExit(f"no Version header in {main}")
    return match.group(1)


def included_files(plugin_dir: Path) -> list[Path]:
    """Every shippable file, sorted so the zip is reproducible."""
    files = []
    for path in sorted(plugin_dir.rglob("*")):
        rel = path.relative_to(plugin_dir)
        if not path.is_file() or path.is_symlink():
            continue
        if EXCLUDED_DIRS & set(rel.parts[:-1]):
            continue
        if path.name in EXCLUDED_NAMES or path.suffix in EXCLUDED_SUFFIXES:
            continue
        files.append(path)
    return files


def build(slug: str, out_dir: Path | None = None) -> Path:
    plugin_dir = PLUGINS / slug
    if not (plugin_dir / f"{slug}.php").is_file():
        raise SystemExit(f"no plugin at {plugin_dir}")
    out_dir = out_dir or ROOT / "dist"
    out_dir.mkdir(parents=True, exist_ok=True)
    target = out_dir / f"{slug}-{plugin_version(plugin_dir)}.zip"
    target.unlink(missing_ok=True)
    with zipfile.ZipFile(target, "w", zipfile.ZIP_DEFLATED) as archive:
        for path in included_files(plugin_dir):
            info = zipfile.ZipInfo(f"{slug}/{path.relative_to(plugin_dir).as_posix()}", FIXED_TIME)
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o644 << 16
            archive.writestr(info, path.read_bytes())
    return target


if __name__ == "__main__":
    print(build(sys.argv[1] if len(sys.argv) > 1 else "qr-share"))
