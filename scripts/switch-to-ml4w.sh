#!/usr/bin/env bash
# Migración rápida: JaKooLit → ML4W (sin reiniciar Fedora)
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Cierra apps Hyprland si puedes. Continuando en 3s..."
sleep 3

bash "$REPO_DIR/scripts/remove-jakoolit.sh"
bash "$REPO_DIR/scripts/install-ml4w.sh"
bash "$REPO_DIR/scripts/faith.sh"
bash "$REPO_DIR/scripts/cursor.sh" 2>/dev/null || true

echo ""
echo "=== Hecho ==="
echo "Cierra sesión y entra en Hyprland (o: hyprctl reload)"
echo "Wallpaper león + sin pokemon + sin errores rojos"
