#!/usr/bin/env bash
# Lenovo V14 — Fedora + Hyprland professional setup
# Based on JaKooLit/Fedora-Hyprland + ML4W hyprland-starter patterns

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$REPO_DIR/Install-Logs"
mkdir -p "$LOG_DIR"
LOG="$LOG_DIR/install-$(date +%Y%m%d-%H%M%S).log"

log() { echo "[$(date +%H:%M:%S)] $*" | tee -a "$LOG"; }
die() { log "ERROR: $*"; exit 1; }

if [[ $EUID -eq 0 ]]; then
  die "No ejecutes como root. Usa tu usuario normal."
fi

if ! command -v dnf >/dev/null 2>&1; then
  die "Este script es para Fedora. Instala Fedora 41+ primero."
fi

log "=== Fedora Hyprland — instalación profesional ==="
log "Repo: $REPO_DIR"

log "Paso 1/5: actualizar sistema (recomendado antes de continuar)"
read -r -p "¿Actualizar ahora con sudo dnf upgrade? [y/N] " ans
if [[ "${ans,,}" == "y" ]]; then
  sudo dnf upgrade -y | tee -a "$LOG"
fi

log "Paso 2/5: JaKooLit Fedora-Hyprland"
JAKOOLIT_DIR="$HOME/Fedora-Hyprland"
if [[ -d "$JAKOOLIT_DIR" ]]; then
  log "Actualizando $JAKOOLIT_DIR"
  git -C "$JAKOOLIT_DIR" pull --ff-only || true
else
  git clone --depth=1 https://github.com/JaKooLit/Fedora-Hyprland.git "$JAKOOLIT_DIR"
fi

cp "$REPO_DIR/preset.sh" "$JAKOOLIT_DIR/preset.sh"
chmod +x "$JAKOOLIT_DIR/install.sh"
log "Ejecutando JaKooLit install.sh con preset profesional..."
(cd "$JAKOOLIT_DIR" && ./install.sh --preset preset.sh) 2>&1 | tee -a "$LOG"

log "Paso 3/5: dotfiles profesionales (override)"
bash "$REPO_DIR/scripts/apply-dotfiles.sh" 2>&1 | tee -a "$LOG"

log "Paso 4/5: herramientas de desarrollo"
bash "$REPO_DIR/scripts/dev-tools.sh" 2>&1 | tee -a "$LOG"

log "Paso 5/5: fe / Mixlr / Cursor"
bash "$REPO_DIR/scripts/faith.sh" 2>&1 | tee -a "$LOG"
bash "$REPO_DIR/scripts/cursor.sh" 2>&1 | tee -a "$LOG"

log "=== Instalación terminada ==="
log "Reinicia: sudo reboot"
log "Login: SDDM → sesión Hyprland"
log "Atajos: SUPER+H ayuda | SUPER+Shift+C Cursor | SUPER+Shift+B Mixlr"
