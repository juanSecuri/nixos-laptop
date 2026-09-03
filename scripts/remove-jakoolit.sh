#!/usr/bin/env bash
# Quita JaKooLit / pokemon / quickshell — prepara para ML4W
set -euo pipefail

echo "=== Eliminando config JaKooLit ==="

# Backup por si acaso
BACKUP="$HOME/.config-backup-jakoolit-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"
for d in hypr waybar rofi kitty swaync wlogout quickshell ags cava wallust Kvantum; do
  [[ -d "$HOME/.config/$d" ]] && cp -a "$HOME/.config/$d" "$BACKUP/" 2>/dev/null || true
done

# Borrar configs JaKooLit
rm -rf \
  "$HOME/.config/hypr" \
  "$HOME/.config/waybar" \
  "$HOME/.config/rofi" \
  "$HOME/.config/kitty" \
  "$HOME/.config/swaync" \
  "$HOME/.config/wlogout" \
  "$HOME/.config/quickshell" \
  "$HOME/.config/ags" \
  "$HOME/.config/cava" \
  "$HOME/.config/wallust" \
  "$HOME/.config/Kvantum" \
  "$HOME/Fedora-Hyprland" \
  2>/dev/null || true

# Quitar pokemon / temas raros de zsh
if [[ -f "$HOME/.zshrc" ]]; then
  sed -i '/pokemon/d' "$HOME/.zshrc" 2>/dev/null || true
  sed -i '/pokecolor/d' "$HOME/.zshrc" 2>/dev/null || true
  sed -i 's/^ZSH_THEME=.*/ZSH_THEME="robbyrussell"/' "$HOME/.zshrc" 2>/dev/null || true
fi

rm -rf "$HOME/.oh-my-zsh/custom/themes/pokemon" 2>/dev/null || true
rm -rf "$HOME/.oh-my-zsh/custom/themes/agnosterzak" 2>/dev/null || true

# fastfetch sin logo pokemon
mkdir -p "$HOME/.config/fastfetch"
cat > "$HOME/.config/fastfetch/config.jsonc" << 'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json",
  "logo": { "type": "none" },
  "modules": ["title", "separator", "os", "kernel", "uptime", "packages", "shell", "wm", "terminal", "cpu", "memory", "disk", "break", "colors"]
}
EOF

echo "Backup en: $BACKUP"
echo "JaKooLit eliminado."
