#!/usr/bin/env bash
# Parchea configs ML4W para Hyprland 0.56+ (quita errores rojos)
set -euo pipefail

CONF="$HOME/.config/hypr/conf"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Parche Hyprland 0.56 ==="

# Sobrescribir con configs fijas del repo
cp -a "$REPO_DIR/dotfiles/.config/hypr/conf/." "$CONF/"
cp -f "$REPO_DIR/dotfiles/.config/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
cp -f "$REPO_DIR/dotfiles/.config/hypr/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"

# Wallpaper león
if [[ -f "$REPO_DIR/assets/wallpapers/wallpaper.jpg" ]]; then
  mkdir -p "$HOME/.config/ml4w/wallpapers"
  cp -f "$REPO_DIR/assets/wallpapers/wallpaper.jpg" "$HOME/.config/ml4w/wallpapers/wallpaper.jpg"
fi

# fastfetch sin pokemon
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

echo "=== Sin errores rojos. Wallpaper león aplicado. ==="
