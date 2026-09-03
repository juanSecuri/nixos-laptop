#!/usr/bin/env bash
# Personalización ML4W completa + herramientas dev (curl o ~/fedora-setup)
# Sin set -e: los pasos opcionales (dev-tools, cursor) nunca abortan el script.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log()  { echo "[$(date +%H:%M:%S)] $*"; }
step() { log "→ $*"; }
ok()   { log "✓ $*"; }
warn() { log "⚠ $*"; }

run_optional() {
  local label="$1"
  shift
  step "$label"
  if "$@"; then
    ok "$label"
  else
    warn "$label falló (continuando)"
  fi
}

# --- Fase 0: repo ---
if [[ -f "$SCRIPT_DIR/../dotfiles/.config/hypr/hyprland.conf" ]]; then
  REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
else
  REPO_DIR="${REPO_DIR:-$HOME/fedora-setup}"
  if [[ ! -f "$REPO_DIR/scripts/ml4w-look.sh" ]]; then
    step "Clonando repo en $REPO_DIR"
    rm -rf "$REPO_DIR" 2>/dev/null || true
    if ! git clone --depth=1 https://github.com/juanSecuri/nixos-laptop.git "$REPO_DIR"; then
      warn "git clone falló — descarga scripts con curl (ver docs)"
      REPO_DIR="$HOME/fedora-setup"
      mkdir -p "$REPO_DIR/scripts"
    fi
  else
    git -C "$REPO_DIR" pull --ff-only 2>/dev/null || true
  fi
fi
export REPO_DIR

echo ""
echo "=== Personalizar ML4W (vidrio + dev tools) ==="
echo "Repo: $REPO_DIR"
echo ""

# --- Fase 1: paquetes base ---
echo "=== FASE 1/5: Paquetes base ==="
run_optional "dnf: temas, terminal, hyprpaper" \
  sudo dnf install -y \
    papirus-icon-theme adwaita-icon-theme \
    fastfetch zsh unzip curl git \
    mozilla-fira-sans-fonts fontawesome-6-free-fonts \
    hyprpaper thunar kitty

# --- Fase 2: look visual (wallpaper, fuentes, GTK) ---
echo ""
echo "=== FASE 2/5: Look visual (ml4w-look) ==="
run_optional "ml4w-look.sh" bash "$REPO_DIR/scripts/ml4w-look.sh"

# --- Fase 3: Hyprland + waybar + rofi + kitty ---
echo ""
echo "=== FASE 3/5: Config Hyprland / waybar / terminal ==="
HYPR="$HOME/.config/hypr"
mkdir -p "$HYPR/conf" "$HOME/.config/kitty" "$HOME/.config/waybar" "$HOME/.config/rofi"
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" "$HOME/.config/fastfetch"

if [[ -f "$REPO_DIR/dotfiles/.config/hypr/hyprland.conf" ]]; then
  cp -f "$REPO_DIR/dotfiles/.config/hypr/hyprland.conf" "$HYPR/hyprland.conf"
  cp -f "$REPO_DIR/dotfiles/.config/hypr/conf/"*.conf "$HYPR/conf/" 2>/dev/null || true
  cp -f "$REPO_DIR/dotfiles/.config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
  cp -f "$REPO_DIR/dotfiles/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
  cp -f "$REPO_DIR/dotfiles/.config/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini" 2>/dev/null || \
    cp -f "$REPO_DIR/dotfiles/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
  cp -a "$REPO_DIR/dotfiles/.config/waybar/." "$HOME/.config/waybar/" 2>/dev/null || true
  cp -a "$REPO_DIR/dotfiles/.config/rofi/." "$HOME/.config/rofi/" 2>/dev/null || true
  cp -f "$REPO_DIR/dotfiles/.config/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc" 2>/dev/null || true
  ok "dotfiles copiados"
else
  warn "dotfiles no encontrados en $REPO_DIR — fase 2 (ml4w-look) ya aplicó lo básico"
fi

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

# --- Fase 4: herramientas dev (opcional, nunca aborta) ---
echo ""
echo "=== FASE 4/5: Herramientas dev (faith, cursor, docker, vscode…) ==="
run_optional "faith.sh (Mixlr + Biblia)" bash "$REPO_DIR/scripts/faith.sh"
run_optional "cursor.sh" bash "$REPO_DIR/scripts/cursor.sh"
run_optional "dev-tools.sh" bash "$REPO_DIR/scripts/dev-tools.sh"

# --- Fase 5: recargar UI (sin hyprctl reload — evita matar wallpaper) ---
echo ""
echo "=== FASE 5/5: Recargar waybar + hyprpaper ==="
if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  pkill -SIGUSR2 waybar 2>/dev/null || true
  systemctl --user restart hyprpaper 2>/dev/null || true
  ok "waybar + hyprpaper recargados (sin hyprctl reload)"
else
  warn "No estás en Hyprland — omite recarga; al iniciar sesión se aplicará todo"
fi

echo ""
echo "=== Listo ==="
echo "Nueva terminal: SUPER+Return (cierra viejas: SUPER+Q)"
echo "Archivos: SUPER+E | Web: SUPER+B | Cursor: SUPER+Shift+C"
echo "Mixlr: SUPER+Shift+B | Biblia: SUPER+Shift+Y"
echo ""
echo "Si faltó Docker/Cursor/VS Code, corre solo dev tools:"
echo "  bash <(curl -fsSL https://raw.githubusercontent.com/juanSecuri/nixos-laptop/main/scripts/install-tools.sh)"
