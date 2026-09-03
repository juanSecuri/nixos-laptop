#!/usr/bin/env bash
# Instala ML4W Hyprland Starter + dotfiles personalizados (fe, león, dev)
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ML4W_DIR="$HOME/hyprland-starter"

echo "=== ML4W Hyprland Starter ==="

# Paquetes Hyprland (Fedora 44)
sudo dnf install -y \
  wget curl git unzip \
  hyprland hyprpaper hyprlock hypridle \
  waybar rofi-wayland kitty dunst \
  thunar xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  qt5-qtwayland qt6-qtwayland \
  firefox fastfetch vim \
  fontawesome-6-free-fonts mozilla-fira-sans-fonts fira-code-fonts \
  wlogout grim slurp wl-clipboard cliphist \
  brightnessctl playerctl pavucontrol \
  network-manager-applet \
  2>/dev/null || sudo dnf install -y hyprland waybar rofi-wayland kitty dunst thunar hyprpaper hyprlock firefox fastfetch wlogout grim slurp wl-clipboard brightnessctl

# COPR Hyprland si hace falta
sudo dnf copr enable -y sdegler/hyprland 2>/dev/null || \
  sudo dnf copr enable -y solopasha/hyprland 2>/dev/null || true

# Clonar ML4W hyprland-starter
if [[ -d "$ML4W_DIR" ]]; then
  git -C "$ML4W_DIR" pull --ff-only || true
else
  git clone --depth=1 https://github.com/mylinuxforwork/hyprland-starter.git "$ML4W_DIR"
fi

# Copiar dotfiles base ML4W
cp -a "$ML4W_DIR/dotfiles/." "$HOME/"

# Aplicar nuestros overrides (fe, león, latam, colores sobrios)
cp -a "$REPO_DIR/dotfiles/." "$HOME/"

# Wallpaper del león
mkdir -p "$HOME/.config/ml4w/wallpapers" "$HOME/Pictures"
if [[ -f "$REPO_DIR/assets/wallpapers/wallpaper.jpg" ]]; then
  cp -f "$REPO_DIR/assets/wallpapers/wallpaper.jpg" "$HOME/.config/ml4w/wallpapers/wallpaper.jpg"
  cp -f "$REPO_DIR/assets/wallpapers/wallpaper.jpg" "$HOME/Pictures/wallpaper.jpg"
fi

# Scripts ejecutables
chmod +x "$HOME/.config/ml4w/settings/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/ml4w/scripts/"*.sh 2>/dev/null || true

# Parche Hyprland 0.56 (sin errores rojos)
bash "$REPO_DIR/scripts/fix-hyprland-056.sh"

# Bash profile limpio (sin pokemon)
if [[ ! -f "$HOME/.bashrc" ]] || ! grep -q "fedora-setup" "$HOME/.bashrc" 2>/dev/null; then
  cat >> "$HOME/.bashrc" << 'EOF'

# fedora-setup
export EDITOR=cursor
export PATH="$HOME/.local/bin:$PATH"
alias rebuild='echo "Fedora: edita ~/.config/hypr y hyprctl reload"'
alias projects='cd ~/Projects 2>/dev/null || mkdir -p ~/Projects && cd ~/Projects'
EOF
fi

echo "=== ML4W instalado ==="
echo "Reinicia sesión o: hyprctl reload && hyprpaper"
