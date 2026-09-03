#!/usr/bin/env bash
# Wallpaper + terminal + carpetas — funciona SIN git pull
set -euo pipefail

REPO_DIR="${REPO_DIR:-$HOME/fedora-setup}"
WALL_DIR="$HOME/.config/ml4w/wallpapers"
WALL_FILE="$WALL_DIR/wallpaper.jpg"
MONITOR="eDP-1"

echo "=== ML4W look ==="

# Paquetes (pide sudo una vez)
sudo dnf install -y papirus-icon-theme adwaita-icon-theme unzip curl \
  google-noto-sans-fonts fira-code-fonts hyprpaper thunar 2>/dev/null || true

# Nerd Font
FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerd"
if ! fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd Font"; then
  echo "Instalando JetBrainsMono Nerd Font..."
  mkdir -p "$FONT_DIR"
  tmpzip="$(mktemp /tmp/jetbrains-nerd.XXXXXX.zip)"
  curl -fsSL -o "$tmpzip" \
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"
  unzip -qo "$tmpzip" -d "$FONT_DIR"
  rm -f "$tmpzip"
  fc-cache -fv "$HOME/.local/share/fonts" 2>/dev/null || true
fi

# Wallpaper
mkdir -p "$WALL_DIR" "$HOME/Pictures"
if [[ -f "$REPO_DIR/assets/wallpapers/ml4w-default.jpg" ]]; then
  cp -f "$REPO_DIR/assets/wallpapers/ml4w-default.jpg" "$WALL_FILE"
elif [[ -s "$WALL_FILE" ]]; then
  echo "Usando wallpaper existente."
else
  curl -fsSL -o "$WALL_FILE" \
    "https://raw.githubusercontent.com/mylinuxforwork/hyprland-starter/main/dotfiles/.config/ml4w/wallpapers/wallpaper.jpg"
fi
cp -f "$WALL_FILE" "$HOME/Pictures/wallpaper.jpg"
echo "Wallpaper: $WALL_FILE"

# Monitor real
if command -v hyprctl &>/dev/null && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  MONITOR="$(hyprctl monitors 2>/dev/null | awk '/^Monitor/{print $2; exit}')"
fi
[[ -z "$MONITOR" ]] && MONITOR="eDP-1"
echo "Monitor: $MONITOR"

# hyprpaper 0.8+
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

# GTK Papirus (carpetas azules)
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
cat > "$HOME/.config/gtk-3.0/settings.ini" << 'EOF'
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Papirus
gtk-font-name=Fira Sans 11
gtk-application-prefer-dark-theme=1
EOF
cp "$HOME/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface icon-theme 'Papirus' 2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true

# Kitty (desde repo si existe, si no descarga)
mkdir -p "$HOME/.config/kitty"
if [[ -f "$REPO_DIR/dotfiles/.config/kitty/kitty.conf" ]]; then
  cp -f "$REPO_DIR/dotfiles/.config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
else
  curl -fsSL -o "$HOME/.config/kitty/kitty.conf" \
    "https://raw.githubusercontent.com/juanSecuri/nixos-laptop/main/dotfiles/.config/kitty/kitty.conf" \
    2>/dev/null || true
fi

# Servicio systemd — wallpaper PERMANENTE (no se cierra)
mkdir -p "$HOME/.config/systemd/user"
if [[ -f "$REPO_DIR/dotfiles/.config/systemd/user/hyprpaper.service" ]]; then
  cp -f "$REPO_DIR/dotfiles/.config/systemd/user/hyprpaper.service" \
    "$HOME/.config/systemd/user/hyprpaper.service"
else
  curl -fsSL -o "$HOME/.config/systemd/user/hyprpaper.service" \
    "https://raw.githubusercontent.com/juanSecuri/nixos-laptop/main/dotfiles/.config/systemd/user/hyprpaper.service" \
    2>/dev/null || true
fi

pkill hyprpaper 2>/dev/null || true
systemctl --user daemon-reload 2>/dev/null || true
systemctl --user enable --now hyprpaper.service 2>/dev/null || {
  echo "systemd no disponible, hyprpaper en background..."
  hyprpaper &
}

sleep 2
if command -v hyprctl &>/dev/null && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  hyprctl hyprpaper wallpaper "${MONITOR},${WALL_FILE},cover" 2>/dev/null || true
fi

echo ""
echo "=== Listo ==="
echo "Wallpaper fijo con systemd. Cierra y abre Thunar (SUPER+E) para carpetas azules."
echo "Nueva terminal: SUPER+Return"
