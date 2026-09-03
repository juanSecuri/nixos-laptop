#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cp -a "$REPO_DIR/dotfiles/." "$HOME/"
if [[ -f "$REPO_DIR/assets/wallpapers/wallpaper.jpg" ]]; then
  mkdir -p "$HOME/.config/ml4w/wallpapers"
  cp -f "$REPO_DIR/assets/wallpapers/wallpaper.jpg" "$HOME/.config/ml4w/wallpapers/wallpaper.jpg"
fi
chmod +x "$HOME/.config/ml4w/settings/"*.sh 2>/dev/null || true
hyprctl reload 2>/dev/null || true
pkill hyprpaper; hyprpaper & 2>/dev/null || true
echo "Dotfiles ML4W aplicados."
