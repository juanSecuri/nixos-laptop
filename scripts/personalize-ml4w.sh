#!/usr/bin/env bash
# Personalización ML4W completa + herramientas dev (curl o ~/fedora-setup)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Si se ejecuta desde /tmp (curl), usar ~/fedora-setup
if [[ -f "$SCRIPT_DIR/../dotfiles/.config/hypr/hyprland.conf" ]]; then
  REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
else
  REPO_DIR="${REPO_DIR:-$HOME/fedora-setup}"
  if [[ ! -f "$REPO_DIR/scripts/ml4w-look.sh" ]]; then
    echo "Clonando repo en $REPO_DIR ..."
    rm -rf "$REPO_DIR" 2>/dev/null || true
    git clone --depth=1 https://github.com/juanSecuri/nixos-laptop.git "$REPO_DIR"
  else
    git -C "$REPO_DIR" pull --ff-only 2>/dev/null || true
  fi
fi
export REPO_DIR

echo "=== Personalizar ML4W (vidrio + dev tools) ==="
echo "Repo: $REPO_DIR"

# Paquetes primero (zsh antes de kitty shell zsh)
sudo dnf install -y \
  papirus-icon-theme adwaita-icon-theme \
  fastfetch zsh unzip curl git \
  mozilla-fira-sans-fonts fontawesome-6-free-fonts \
  hyprpaper thunar kitty \
  2>/dev/null || true

# 1) Wallpaper systemd + fuentes + GTK
bash "$REPO_DIR/scripts/ml4w-look.sh"

# 2) Hyprland + terminal + temas
HYPR="$HOME/.config/hypr"
mkdir -p "$HYPR/conf" "$HOME/.config/kitty" "$HOME/.config/waybar" "$HOME/.config/rofi"
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" "$HOME/.config/fastfetch"

cp -f "$REPO_DIR/dotfiles/.config/hypr/hyprland.conf" "$HYPR/hyprland.conf"
cp -f "$REPO_DIR/dotfiles/.config/hypr/conf/"*.conf "$HYPR/conf/"
cp -f "$REPO_DIR/dotfiles/.config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
cp -f "$REPO_DIR/dotfiles/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
cp -f "$REPO_DIR/dotfiles/.config/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini" 2>/dev/null || \
  cp -f "$REPO_DIR/dotfiles/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
cp -a "$REPO_DIR/dotfiles/.config/waybar/." "$HOME/.config/waybar/"
cp -a "$REPO_DIR/dotfiles/.config/rofi/." "$HOME/.config/rofi/"
cp -f "$REPO_DIR/dotfiles/.config/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc" 2>/dev/null || true

# Papirus + Thunar (carpetas azules)
if [[ -d /usr/share/icons/Papirus ]]; then
  sudo gtk-update-icon-cache -f /usr/share/icons/Papirus 2>/dev/null || true
fi
gsettings set org.gnome.desktop.interface icon-theme 'Papirus' 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
pkill thunar 2>/dev/null || true

# Zsh + starship (terminal pro, sin pokemon)
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 2>/dev/null || true
fi
if [[ -f "$HOME/.zshrc" ]]; then
  sed -i '/pokemon/d' "$HOME/.zshrc" 2>/dev/null || true
  sed -i 's/^ZSH_THEME=.*/ZSH_THEME="robbyrussell"/' "$HOME/.zshrc" 2>/dev/null || true
fi
if ! command -v starship >/dev/null 2>&1; then
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y 2>/dev/null || true
fi
if [[ -f "$HOME/.zshrc" ]] && ! grep -q starship "$HOME/.zshrc" 2>/dev/null; then
  echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
fi
if command -v zsh >/dev/null 2>&1; then
  grep -q '^shell zsh' "$HOME/.config/kitty/kitty.conf" 2>/dev/null || echo 'shell zsh' >> "$HOME/.config/kitty/kitty.conf"
fi

# 3) Dev + fe (no aborta si falla red)
bash "$REPO_DIR/scripts/faith.sh" 2>/dev/null || true
bash "$REPO_DIR/scripts/cursor.sh" 2>/dev/null || echo "Cursor: instalar manual si falla red"
bash "$REPO_DIR/scripts/dev-tools.sh" 2>/dev/null || echo "dev-tools: revisa salida arriba"

# 4) Recargar sin romper wallpaper
if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  hyprctl reload 2>/dev/null || true
  pkill -SIGUSR2 waybar 2>/dev/null || true
  systemctl --user restart hyprpaper 2>/dev/null || true
fi

echo ""
echo "=== Listo ==="
echo "Nueva terminal: SUPER+Return (cierra viejas: SUPER+Q)"
echo "Archivos: SUPER+E | Web: SUPER+B | Cursor: SUPER+Shift+C"
echo "Mixlr: SUPER+Shift+B | Biblia: SUPER+Shift+Y"
