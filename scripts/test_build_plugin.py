"""build_plugin.py ships the plugin without tests or dev files."""

from __future__ import annotations

import zipfile
from pathlib import Path

import build_plugin


def test_zip_contains_plugin_and_excludes_dev_files(tmp_path: Path) -> None:
    target = build_plugin.build("qr-share", tmp_path)
    version = build_plugin.plugin_version(build_plugin.PLUGINS / "qr-share")
    assert target.name == f"qr-share-{version}.zip"

    names = set(zipfile.ZipFile(target).namelist())
    assert "qr-share/qr-share.php" in names
    assert "qr-share/assets/js/qr-share.js" in names
    assert "qr-share/assets/vendor/qrcode-generator/LICENSE.txt" in names
    assert not [n for n in names if "/tests/" in n or n.endswith((".map", ".log"))]
    assert all(n.startswith("qr-share/") for n in names)


def test_zip_is_reproducible(tmp_path: Path) -> None:
    first = build_plugin.build("qr-share", tmp_path / "a").read_bytes()
    second = build_plugin.build("qr-share", tmp_path / "b").read_bytes()
    assert first == second
