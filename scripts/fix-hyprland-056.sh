#!/usr/bin/env bash
# Solo parche Hyprland 0.56 — mantiene tema/colores ML4W
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONF="$HOME/.config/hypr/conf"

echo "=== Parche Hyprland 0.56 (tema ML4W intacto) ==="

cp -f "$REPO_DIR/dotfiles/.config/hypr/conf/layouts.conf" "$CONF/layouts.conf"
cp -f "$REPO_DIR/dotfiles/.config/hypr/conf/gestures.conf" "$CONF/gestures.conf"
cp -f "$REPO_DIR/dotfiles/.config/hypr/conf/faith.conf" "$CONF/faith.conf"

# Tema ML4W completo (waybar, rofi, kitty, hypr colores)
cp -a "$REPO_DIR/dotfiles/.config/waybar/." "$HOME/.config/waybar/" 2>/dev/null || true
cp -a "$REPO_DIR/dotfiles/.config/rofi/." "$HOME/.config/rofi/" 2>/dev/null || true
cp -a "$REPO_DIR/dotfiles/.config/kitty/." "$HOME/.config/kitty/" 2>/dev/null || true
cp -a "$REPO_DIR/dotfiles/.config/dunst/." "$HOME/.config/dunst/" 2>/dev/null || true
cp -f "$REPO_DIR/dotfiles/.config/hypr/conf/general.conf" "$CONF/general.conf"
cp -f "$REPO_DIR/dotfiles/.config/hypr/conf/decoration.conf" "$CONF/decoration.conf"
cp -f "$REPO_DIR/dotfiles/.config/ml4w/settings/waybar-quicklinks.json" "$HOME/.config/ml4w/settings/waybar-quicklinks.json"

# Asegurar faith en hyprland.conf
if ! grep -q "faith.conf" "$HOME/.config/hypr/hyprland.conf" 2>/dev/null; then
  echo "source = ~/.config/hypr/conf/faith.conf" >> "$HOME/.config/hypr/hyprland.conf"
fi

# GTK/Thunar como ML4W (oscuro + iconos Adwaita azules)
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface icon-theme 'Adwaita' 2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
mkdir -p "$HOME/.config/gtk-3.0"
cat > "$HOME/.config/gtk-3.0/settings.ini" << 'EOF'
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Adwaita
gtk-application-prefer-dark-theme=1
EOF

# Wallpaper ML4W (edificios) — clone o asset del repo
ML4W_WALL="$HOME/hyprland-starter/dotfiles/.config/ml4w/wallpapers/wallpaper.jpg"
REPO_WALL="$REPO_DIR/assets/wallpapers/ml4w-default.jpg"
if [[ -f "$ML4W_WALL" ]]; then
  mkdir -p "$HOME/.config/ml4w/wallpapers" "$HOME/Pictures"
  cp -f "$ML4W_WALL" "$HOME/.config/ml4w/wallpapers/wallpaper.jpg"
  cp -f "$ML4W_WALL" "$HOME/Pictures/wallpaper.jpg"
elif [[ -f "$REPO_WALL" ]]; then
  mkdir -p "$HOME/.config/ml4w/wallpapers" "$HOME/Pictures"
  cp -f "$REPO_WALL" "$HOME/.config/ml4w/wallpapers/wallpaper.jpg"
  cp -f "$REPO_WALL" "$HOME/Pictures/wallpaper.jpg"
fi

# fastfetch limpio
mkdir -p "$HOME/.config/fastfetch"
cat > "$HOME/.config/fastfetch/config.jsonc" << 'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json",
  "logo": { "type": "none" },
  "modules": ["title", "separator", "os", "kernel", "uptime", "packages", "shell", "wm", "terminal", "cpu", "memory", "disk", "break", "colors"]
}
EOF

hyprctl reload
pkill hyprpaper 2>/dev/null || true
hyprpaper & 2>/dev/null || true
pkill -SIGUSR2 waybar 2>/dev/null || true

echo "=== Tema ML4W aplicado. Sin errores rojos. ==="
