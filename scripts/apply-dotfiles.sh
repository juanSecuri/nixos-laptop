#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HYPR_USER="$HOME/.config/hypr/UserConfigs"
WAYBAR_STYLE="$HOME/.config/waybar/style"

mkdir -p "$HYPR_USER" "$WAYBAR_STYLE"

# JaKooLit UserConfigs overrides — look profesional, sin efectos exagerados
cp -f "$REPO_DIR/dotfiles/hypr/UserConfigs/"* "$HYPR_USER/"

# Waybar: estilo minimal si existe el preset de JaKooLit
if [[ -d "$HOME/.config/waybar/style" ]]; then
  for candidate in \
    "[Extra] Minimal.css" \
    "[TOP] Minimal.css" \
    "minimal.css" \
    "style.css"; do
    if [[ -f "$HOME/.config/waybar/style/$candidate" ]]; then
      ln -sfn "$HOME/.config/waybar/style/$candidate" "$HOME/.config/waybar/style.css"
      break
    fi
  done
fi

# Wallpaper del león (fe)
mkdir -p "$HOME/.config/hypr/wallpaper_effects"
if [[ -f "$REPO_DIR/assets/wallpapers/wallpaper.jpg" ]]; then
  cp -f "$REPO_DIR/assets/wallpapers/wallpaper.jpg" \
    "$HOME/.config/hypr/wallpaper_effects/wallpaper.jpg"
  if command -v swww >/dev/null 2>&1; then
    swww-daemon 2>/dev/null || true
    swww img "$HOME/.config/hypr/wallpaper_effects/wallpaper.jpg" --transition-type fade 2>/dev/null || true
  fi
fi

# Zsh: tema sobrio (sin pokemon)
if [[ -f "$HOME/.zshrc" ]]; then
  sed -i 's/^ZSH_THEME=.*/ZSH_THEME="robbyrussell"/' "$HOME/.zshrc" 2>/dev/null || true
fi

echo "Dotfiles profesionales aplicados."
