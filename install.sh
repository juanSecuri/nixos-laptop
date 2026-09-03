#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$REPO_DIR/Install-Logs"
mkdir -p "$LOG_DIR"
LOG="$LOG_DIR/install-$(date +%Y%m%d-%H%M%S).log"

log() { echo "[$(date +%H:%M:%S)] $*" | tee -a "$LOG"; }

if [[ $EUID -eq 0 ]]; then
  echo "No ejecutes como root."
  exit 1
fi

log "=== Setup Fedora — ML4W Hyprland (dev + fe) ==="

bash "$REPO_DIR/scripts/remove-jakoolit.sh" 2>&1 | tee -a "$LOG"
bash "$REPO_DIR/scripts/install-ml4w.sh" 2>&1 | tee -a "$LOG"
bash "$REPO_DIR/scripts/faith.sh" 2>&1 | tee -a "$LOG"
bash "$REPO_DIR/scripts/cursor.sh" 2>&1 | tee -a "$LOG" || log "Cursor: instalar manualmente si falla red"
bash "$REPO_DIR/scripts/dev-tools.sh" 2>&1 | tee -a "$LOG" || true

log "=== Listo. Reinicia: sudo reboot ==="
log "Login → Hyprland | SUPER+Shift+B Mixlr | SUPER+Shift+C Cursor"
