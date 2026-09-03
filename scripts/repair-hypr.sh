#!/usr/bin/env bash
# Repara Hyprland tras crash / safe mode — config limpia ML4W + 0.56
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HYPR="$HOME/.config/hypr"
BACKUP="$HOME/.config-backup-hypr-$(date +%Y%m%d-%H%M%S)"

echo "=== Reparar Hyprland (safe mode / crash) ==="

mkdir -p "$BACKUP"
[[ -d "$HYPR" ]] && cp -a "$HYPR" "$BACKUP/" 2>/dev/null || true

# Lua roto o configs mezcladas → safe mode
rm -f "$HYPR/hyprland.lua" "$HYPR/hyprland.conf.bak" 2>/dev/null || true

# Config hypr 100% desde nuestro repo (sin basura ML4W/JaKooLit)
mkdir -p "$HYPR/conf"
cp -f "$REPO_DIR/dotfiles/.config/hypr/hyprland.conf" "$HYPR/hyprland.conf"
cp -f "$REPO_DIR/dotfiles/.config/hypr/conf/"*.conf "$HYPR/conf/"

# Tema ML4W
cp -a "$REPO_DIR/dotfiles/.config/waybar/." "$HOME/.config/waybar/"
cp -a "$REPO_DIR/dotfiles/.config/rofi/." "$HOME/.config/rofi/"
cp -a "$REPO_DIR/dotfiles/.config/kitty/." "$HOME/.config/kitty/"
cp -a "$REPO_DIR/dotfiles/.config/dunst/." "$HOME/.config/dunst/"
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
cp -f "$REPO_DIR/dotfiles/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini" 2>/dev/null || true
cp -f "$REPO_DIR/dotfiles/.config/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini" 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface icon-theme 'Papirus' 2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
mkdir -p "$HOME/.config/ml4w/settings"
cp -f "$REPO_DIR/dotfiles/.config/ml4w/settings/"* "$HOME/.config/ml4w/settings/" 2>/dev/null || true

# ML4W scripts (si existe el clone)
if [[ -d "$HOME/hyprland-starter/dotfiles/.config/ml4w/scripts" ]]; then
  mkdir -p "$HOME/.config/ml4w/scripts"
  cp -a "$HOME/hyprland-starter/dotfiles/.config/ml4w/scripts/." "$HOME/.config/ml4w/scripts/"
  chmod +x "$HOME/.config/ml4w/scripts/"*.sh 2>/dev/null || true
fi
chmod +x "$HOME/.config/ml4w/settings/"*.sh 2>/dev/null || true

bash "$REPO_DIR/scripts/ml4w-look.sh"

echo ""
echo "=== Reparado ==="
echo "Backup viejo: $BACKUP"
echo "Cierra sesión y entra en Hyprland (no uses 'Load config' en safe mode)."
echo "El aviso amarillo de .conf es normal en 0.56 — no es error."
