#!/usr/bin/env python3
"""Summarize the technologies across a GitHub user's non-fork repos.

Usage: gh_tech_scan.py [--user aallbrig] [--limit N]

Prints languages by repo count, file-name signals and the most common dependencies.
Needs the GitHub CLI logged in. Use the output to decide which technologies belong in pages/home.md.
"""

from __future__ import annotations

import argparse
import base64
import json
import re
import subprocess
from collections import Counter
from concurrent.futures import ThreadPoolExecutor

MANIFESTS = ("package.json", "go.mod", "requirements.txt", "pyproject.toml")
SIGNALS = {
    "Docker": r"(^|/)Dockerfile",
    "Docker Compose": r"docker-compose|compose\.ya?ml",
    "Terraform": r"\.tf$",
    "GitHub Actions": r"^\.github/workflows/",
    "Taskfile": r"(^|/)Taskfile\.ya?ml",
    "Makefile": r"(^|/)Makefile$",
    "pre-commit": r"\.pre-commit-config",
    "tmuxinator": r"\.tmuxinator",
    "Playwright": r"playwright",
    "Jest": r"jest\.config|\.test\.js",
    "Helm": r"Chart\.yaml",
    "AWS SAM": r"template\.ya?ml|samconfig",
    "Hugo": r"(^|/)hugo\.(toml|ya?ml)",
    "Eleventy": r"\.eleventy",
    "Unity": r"ProjectSettings/ProjectVersion",
    "Godot": r"project\.godot",
    "Arduino": r"\.ino$",
    "Ansible": r"ansible|playbook",
    "Vagrant": r"Vagrantfile",
    "systemd": r"\.service$",
    "nginx": r"nginx",
    "OpenAPI": r"openapi|swagger",
    "Laravel": r"artisan",
    "Prometheus": r"prometheus",
    "Grafana": r"grafana",
}


def gh(*args: str) -> str:
    result = subprocess.run(["gh", *args], capture_output=True, text=True, check=False)  # noqa: S607
    return result.stdout if result.returncode == 0 else ""


def scan_repo(user: str, repo: str) -> dict[str, object]:
    langs = json.loads(gh("api", f"repos/{user}/{repo}/languages") or "{}")
    tree = gh("api", f"repos/{user}/{repo}/git/trees/HEAD?recursive=1", "--jq", '[.tree[].path]|join("\\n")')
    deps: list[str] = []
    for manifest in MANIFESTS:
        raw = gh("api", f"repos/{user}/{repo}/contents/{manifest}", "--jq", ".content")
        if not raw.strip():
            continue
        text = base64.b64decode(raw).decode("utf-8", "replace")
        if manifest == "package.json":
            try:
                data = json.loads(text)
            except json.JSONDecodeError:
                continue
            deps += [f"npm:{k}" for k in {**data.get("dependencies", {}), **data.get("devDependencies", {})}]
        elif manifest == "go.mod":
            deps += [f"go:{m}" for m in re.findall(r"^\s*([\w.\-/]+\.\w+/[\w.\-/]+)\s+v", text, re.M)]
        else:
            deps += [f"py:{m.lower()}" for m in re.findall(r'^\s*"?([A-Za-z][\w\-.]+)\s*(?:[>=<~!\[]|$|")', text, re.M)]
    return {"langs": langs, "tree": tree, "deps": deps}


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--user", default="aallbrig")
    ap.add_argument("--limit", type=int, default=200)
    args = ap.parse_args()

    listing = gh("repo", "list", args.user, "--limit", str(args.limit), "--json", "name,isFork")
    repos = [r["name"] for r in json.loads(listing or "[]") if not r["isFork"]]
    with ThreadPoolExecutor(max_workers=8) as pool:
        results = list(pool.map(lambda r: scan_repo(args.user, r), repos))

    langs: Counter[str] = Counter()
    signals: Counter[str] = Counter()
    deps: Counter[str] = Counter()
    for res in results:
        langs.update(res["langs"])  # type: ignore[arg-type]
        deps.update(set(res["deps"]))  # type: ignore[arg-type]
        for name, pattern in SIGNALS.items():
            if re.search(pattern, str(res["tree"]), re.M | re.I):
                signals[name] += 1
    print(f"{len(repos)} non-fork repos\n")
    print("LANGUAGES (bytes):", ", ".join(f"{k} {v}" for k, v in langs.most_common(25)))
    print("\nSIGNALS (repos):", ", ".join(f"{k} {v}" for k, v in signals.most_common()))
    print("\nDEPENDENCIES (repos):", ", ".join(f"{k} {v}" for k, v in deps.most_common(60)))


if __name__ == "__main__":
    main()
