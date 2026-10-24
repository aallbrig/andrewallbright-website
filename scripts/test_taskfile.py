"""Every `task X` named in docs or CI must exist in Taskfile.yml."""

from __future__ import annotations

import re
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
DOCS = [
    ROOT / "README.md",
    ROOT / "CLAUDE.md",
    ROOT / "wp-content" / "TODO.md",
    *sorted((ROOT / ".github" / "workflows").glob("*.yaml")),
]


def test_documented_tasks_exist() -> None:
    defined = set(yaml.safe_load((ROOT / "Taskfile.yml").read_text())["tasks"])
    named = set()
    for doc in DOCS:
        named |= set(re.findall(r"\btask ([a-z][a-z:_-]*)", doc.read_text()))
    ignored = {"setup", "lint", "test", "ci"} & named  # sanity: these must be present anyway
    assert ignored <= defined
    missing = sorted(t for t in named if t not in defined)
    assert not missing, f"tasks referenced but not defined: {missing}"
