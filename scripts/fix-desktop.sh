#!/usr/bin/env bash
# Arregla errores Hyprland 0.56 + look profesional (sin anime/pokemon)
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HYPR="$HOME/.config/hypr"

echo "=== Arreglando Hyprland ==="

# 1. Comentar opciones obsoletas en Hyprland 0.56+
if [[ -f "$HYPR/configs/SystemSettings.conf" ]]; then
  sed -i '/pseudotile/s/^/# /' "$HYPR/configs/SystemSettings.conf" || true
  sed -i '/^[[:space:]]*vfr[[:space:]]*=/s/^/# /' "$HYPR/configs/SystemSettings.conf" || true
fi

if [[ -f "$HYPR/configs/Keybinds.conf" ]]; then
  sed -i 's/, togglesplit/, layoutmsg, togglesplit/g' "$HYPR/configs/Keybinds.conf" || true
  sed -i 's/dispatch togglesplit/dispatch layoutmsg togglesplit/g' "$HYPR/configs/Keybinds.conf" || true
fi

# 2. Quitar pokemon del terminal (fastfetch)
if [[ -f "$HOME/.config/fastfetch/config.jsonc" ]]; then
  sed -i 's/"type": "small"/"type": "none"/' "$HOME/.config/fastfetch/config.jsonc" 2>/dev/null || true
fi

# Desactivar pokemon scripts en zsh si existen
if [[ -f "$HOME/.zshrc" ]]; then
  sed -i '/pokemon/s/^/# /' "$HOME/.zshrc" 2>/dev/null || true
fi

# 3. Wallpaper sobrio (fe)
WALL="$REPO_DIR/assets/wallpapers/wallpaper.jpg"
mkdir -p "$HOME/Pictures" "$HYPR/wallpaper_effects"
if [[ -f "$WALL" ]]; then
  cp -f "$WALL" "$HOME/Pictures/wallpaper.jpg"
  cp -f "$WALL" "$HYPR/wallpaper_effects/wallpaper.jpg"
  if command -v swww >/dev/null 2>&1; then
    swww-daemon 2>/dev/null || true
    swww img "$HOME/Pictures/wallpaper.jpg" --transition-type fade 2>/dev/null || true
  fi
  if command -v wallust >/dev/null 2>&1; then
    wallust run "$HOME/Pictures/wallpaper.jpg" 2>/dev/null || true
  fi
fi

# 4. Aplicar overrides profesionales del repo
if [[ -d "$REPO_DIR/dotfiles/hypr/UserConfigs" ]]; then
  mkdir -p "$HYPR/UserConfigs"
  cp -f "$REPO_DIR/dotfiles/hypr/UserConfigs/"* "$HYPR/UserConfigs/" 2>/dev/null || true
fi

# 5. Waybar estilo minimal
if [[ -d "$HOME/.config/waybar/style" ]]; then
  for f in "[Extra] Minimal.css" "[TOP] Minimal.css" "minimal.css"; do
    if [[ -f "$HOME/.config/waybar/style/$f" ]]; then
      ln -sfn "$HOME/.config/waybar/style/$f" "$HOME/.config/waybar/style.css"
      break
    fi
  done
  pkill -SIGUSR2 waybar 2>/dev/null || true
fi

hyprctl reload 2>/dev/null || true

echo "=== Listo ==="
echo "Si aún hay errores rojos: cd ~/Fedora-Hyprland/Hyprland-Dots && git pull && ./copy.sh"
