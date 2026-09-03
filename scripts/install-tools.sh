#!/usr/bin/env bash
# Solo herramientas dev + Cursor + faith — SIN cambios Hyprland / wallpaper / waybar.
# Uso: bash install-tools.sh   o   bash <(curl -fsSL .../install-tools.sh)
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log()  { echo "[$(date +%H:%M:%S)] $*"; }
warn() { log "⚠ $*"; }

run_optional() {
  local label="$1"
  shift
  log "→ $label"
  if "$@"; then
    log "✓ $label"
  else
    warn "$label falló (continuando)"
  fi
}

# Repo local o ~/fedora-setup o curl directo
if [[ -f "$SCRIPT_DIR/faith.sh" ]]; then
  REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
elif [[ -f "$HOME/fedora-setup/scripts/faith.sh" ]]; then
  REPO_DIR="$HOME/fedora-setup"
else
  REPO_DIR="${REPO_DIR:-$HOME/fedora-setup}"
  mkdir -p "$REPO_DIR/scripts"
  RAW="https://raw.githubusercontent.com/juanSecuri/nixos-laptop/main/scripts"
  for f in faith.sh cursor.sh dev-tools.sh; do
    if [[ ! -f "$REPO_DIR/scripts/$f" ]]; then
      log "Descargando $f..."
      curl -fsSL -o "$REPO_DIR/scripts/$f" "$RAW/$f" || warn "no se pudo descargar $f"
      chmod +x "$REPO_DIR/scripts/$f" 2>/dev/null || true
    fi
  done
fi
export REPO_DIR

echo ""
echo "=== Instalar herramientas dev (sin Hyprland) ==="
echo "Repo: $REPO_DIR"
echo ""

run_optional "faith.sh (Mixlr + Biblia)" bash "$REPO_DIR/scripts/faith.sh"
run_optional "cursor.sh" bash "$REPO_DIR/scripts/cursor.sh"
run_optional "dev-tools.sh (Docker, VS Code, etc.)" bash "$REPO_DIR/scripts/dev-tools.sh"

echo ""
echo "=== Listo ==="
echo "Cursor: cursor | SUPER+Shift+C"
echo "Mixlr: SUPER+Shift+B | Biblia: SUPER+Shift+Y"
echo "Docker: cierra sesión para grupo docker, luego: docker run hello-world"
