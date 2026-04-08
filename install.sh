#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$HOME/.config"

cp -a "$ROOT/.config/quickshell" "$HOME/.config/"
cp -a "$ROOT/.config/caelestia" "$HOME/.config/"
cp -a "$ROOT/.config/hypr" "$HOME/.config/"

echo "Restored dotfiles into $HOME/.config"
