#!/usr/bin/env bash
# Wallpaper + terminal + carpetas como ML4W (GitHub demo)
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WALL_DIR="$HOME/.config/ml4w/wallpapers"
WALL_FILE="$WALL_DIR/wallpaper.jpg"

echo "=== ML4W look: wallpaper, terminal, carpetas ==="

# Paquetes visuales
sudo dnf install -y \
  papirus-icon-theme adwaita-icon-theme \
  google-noto-sans-fonts fira-code-fonts \
  hyprpaper thunar \
  2>/dev/null || true

# Nerd Font para kitty (como ML4W)
FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerd"
if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
  echo "Instalando JetBrainsMono Nerd Font..."
  mkdir -p "$FONT_DIR"
  tmpzip="$(mktemp /tmp/jetbrains-nerd.XXXXXX.zip)"
  curl -fsSL -o "$tmpzip" \
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"
  unzip -qo "$tmpzip" -d "$FONT_DIR"
  rm -f "$tmpzip"
  fc-cache -fv "$HOME/.local/share/fonts" 2>/dev/null || true
fi

# Wallpaper ML4W (edificios)
mkdir -p "$WALL_DIR" "$HOME/Pictures"
if [[ -f "$REPO_DIR/assets/wallpapers/ml4w-default.jpg" ]]; then
  cp -f "$REPO_DIR/assets/wallpapers/ml4w-default.jpg" "$WALL_FILE"
elif [[ -f "$HOME/hyprland-starter/dotfiles/.config/ml4w/wallpapers/wallpaper.jpg" ]]; then
  cp -f "$HOME/hyprland-starter/dotfiles/.config/ml4w/wallpapers/wallpaper.jpg" "$WALL_FILE"
else
  echo "Descargando wallpaper ML4W..."
  curl -fsSL -o "$WALL_FILE" \
    "https://raw.githubusercontent.com/mylinuxforwork/hyprland-starter/main/dotfiles/.config/ml4w/wallpapers/wallpaper.jpg"
fi
cp -f "$WALL_FILE" "$HOME/Pictures/wallpaper.jpg"

if [[ ! -s "$WALL_FILE" ]]; then
  echo "ERROR: no hay wallpaper en $WALL_FILE"
  exit 1
fi
echo "Wallpaper OK: $WALL_FILE ($(du -h "$WALL_FILE" | cut -f1))"

# Detectar monitor (Lenovo suele ser eDP-1)
MONITOR="eDP-1"
if command -v hyprctl &>/dev/null && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  MONITOR="$(hyprctl monitors 2>/dev/null | awk '/^Monitor/{print $2; exit}')"
  [[ -z "$MONITOR" ]] && MONITOR="eDP-1"
fi
echo "Monitor: $MONITOR"

# hyprpaper 0.8+ — sintaxis nueva (la vieja preload/wallpaper = ya NO funciona)
mkdir -p "$HOME/.config/hypr"
cat > "$HOME/.config/hypr/hyprpaper.conf" << EOF
splash = false

wallpaper {
    monitor = ${MONITOR}
    path = ${WALL_FILE}
    fit_mode = cover
}

wallpaper {
    monitor =
    path = ${WALL_FILE}
    fit_mode = cover
}
EOF

# GTK + iconos (carpetas azules Papirus)
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
cp -f "$REPO_DIR/dotfiles/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini" 2>/dev/null || true
cp -f "$REPO_DIR/dotfiles/.config/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini" 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface icon-theme 'Papirus' 2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface font-name 'Fira Sans 11' 2>/dev/null || true

# Kitty ML4W
mkdir -p "$HOME/.config/kitty"
cp -f "$REPO_DIR/dotfiles/.config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# Reiniciar servicios visuales
if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  pkill hyprpaper 2>/dev/null || true
  sleep 1
  hyprpaper &
  sleep 2
  hyprctl hyprpaper wallpaper "${MONITOR},${WALL_FILE},cover" 2>/dev/null || true
  pkill -SIGUSR2 waybar 2>/dev/null || true
  hyprctl reload 2>/dev/null || true
fi

echo ""
echo "=== Listo ==="
echo "Si sigue negro: cierra sesión y entra en Hyprland."
echo "Prueba manual: hyprpaper &"
echo "Thunar: cierra y abre con SUPER+E"
