#!/usr/bin/env bash
# Install pinned, checksum-verified developer tools into ~/.local/bin (idempotent).
# Usage: scripts/install_tools.sh [composer|actionlint]...   (default: both)
set -euo pipefail

COMPOSER_VERSION="2.10.3"
ACTIONLINT_VERSION="1.7.12"
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$BIN_DIR"

install_composer() {
  if [ "$(composer --version 2>/dev/null | awk '{print $3}')" = "$COMPOSER_VERSION" ]; then
    echo "composer $COMPOSER_VERSION already installed"
    return
  fi
  local base="https://getcomposer.org/download/$COMPOSER_VERSION"
  curl -fsSL "$base/composer.phar" -o "$tmp/composer.phar"
  curl -fsSL "$base/composer.phar.sha256sum" -o "$tmp/composer.phar.sha256sum"
  (cd "$tmp" && sha256sum --check --strict composer.phar.sha256sum)
  install -m 0755 "$tmp/composer.phar" "$BIN_DIR/composer"
  echo "installed composer $COMPOSER_VERSION to $BIN_DIR/composer"
}

install_actionlint() {
  if [ "$(actionlint -version 2>/dev/null | head -n1)" = "$ACTIONLINT_VERSION" ]; then
    echo "actionlint $ACTIONLINT_VERSION already installed"
    return
  fi
  local name="actionlint_${ACTIONLINT_VERSION}_linux_amd64.tar.gz"
  local base="https://github.com/rhysd/actionlint/releases/download/v$ACTIONLINT_VERSION"
  curl -fsSL "$base/$name" -o "$tmp/$name"
  curl -fsSL "$base/actionlint_${ACTIONLINT_VERSION}_checksums.txt" -o "$tmp/checksums.txt"
  (cd "$tmp" && grep " $name\$" checksums.txt | sha256sum --check --strict -)
  tar -xzf "$tmp/$name" -C "$tmp" actionlint
  install -m 0755 "$tmp/actionlint" "$BIN_DIR/actionlint"
  echo "installed actionlint $ACTIONLINT_VERSION to $BIN_DIR/actionlint"
}

targets=("$@")
[ "${#targets[@]}" -gt 0 ] || targets=(composer actionlint)
for target in "${targets[@]}"; do
  case "$target" in
    composer) install_composer ;;
    actionlint) install_actionlint ;;
    *) echo "unknown tool: $target" >&2; exit 2 ;;
  esac
done
