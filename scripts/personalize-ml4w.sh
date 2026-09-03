#!/usr/bin/env bash
# Personalización ML4W completa + herramientas dev
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Personalizar ML4W (vidrio + dev tools) ==="

# 1) Look visual (wallpaper systemd, fuentes, gtk)
bash "$REPO_DIR/scripts/ml4w-look.sh"

# 2) Hyprland dotfiles (opacidad, blur, terminal)
HYPR="$HOME/.config/hypr"
mkdir -p "$HYPR/conf"
cp -f "$REPO_DIR/dotfiles/.config/hypr/hyprland.conf" "$HYPR/hyprland.conf"
cp -f "$REPO_DIR/dotfiles/.config/hypr/conf/"*.conf "$HYPR/conf/"
cp -f "$REPO_DIR/dotfiles/.config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
cp -f "$REPO_DIR/dotfiles/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
cp -f "$REPO_DIR/dotfiles/.config/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini" 2>/dev/null || \
  cp -f "$REPO_DIR/dotfiles/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
mkdir -p "$HOME/.config/fastfetch"
cp -f "$REPO_DIR/dotfiles/.config/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc" 2>/dev/null || true

# 3) Paquetes visuales + shell pro
sudo dnf install -y \
  papirus-icon-theme adwaita-icon-theme \
  fastfetch zsh unzip curl \
  mozilla-fira-sans-fonts fontawesome-6-free-fonts \
  2>/dev/null || true

# Iconos Papirus (carpetas azules)
if [[ -d /usr/share/icons/Papirus ]]; then
  sudo gtk-update-icon-cache -f /usr/share/icons/Papirus 2>/dev/null || true
fi
gsettings set org.gnome.desktop.interface icon-theme 'Papirus' 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true

# Zsh limpio (sin pokemon) + prompt starship
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

# 4) Herramientas dev (opcional, no falla si algo falta)
bash "$REPO_DIR/scripts/faith.sh" 2>/dev/null || true
bash "$REPO_DIR/scripts/cursor.sh" 2>/dev/null || echo "Cursor: instalar manual si falla red"
bash "$REPO_DIR/scripts/dev-tools.sh" 2>/dev/null || echo "dev-tools: revisa salida arriba"

# 5) Recargar Hyprland SIN matar hyprpaper
if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  hyprctl reload 2>/dev/null || true
  pkill -SIGUSR2 waybar 2>/dev/null || true
  systemctl --user restart hyprpaper 2>/dev/null || true
fi

echo ""
echo "=== Listo ==="
echo "Nueva terminal: SUPER+Return (cierra las viejas con SUPER+Q)"
echo "Archivos azules: SUPER+E"
echo "Web: SUPER+B | Cursor: SUPER+Shift+C"
echo "Mixlr: SUPER+Shift+B | Biblia: SUPER+Shift+Y"
