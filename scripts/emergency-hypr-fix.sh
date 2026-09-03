#!/usr/bin/env bash
# EMERGENCIA — corre desde Safe Mode (SUPER+Q → kitty)
set -euo pipefail

REPO="${HOME}/fedora-setup"
if [[ ! -d "$REPO" ]]; then
  echo "No existe ~/fedora-setup — clona el repo primero."
  exit 1
fi

cd "$REPO"
git fetch origin 2>/dev/null || true
git reset --hard origin/main 2>/dev/null || true
chmod +x scripts/*.sh

# Mata config rota que causa safe mode
rm -f "${HOME}/.config/hypr/hyprland.lua" 2>/dev/null || true

bash scripts/repair-hypr.sh
bash scripts/ml4w-look.sh

echo ""
echo "LISTO. Ahora:"
echo "  1. SUPER+M  (salir de Hyprland)"
echo "  2. Vuelve a entrar en Hyprland"
echo "  3. NO pulses 'Load config' en safe mode"
