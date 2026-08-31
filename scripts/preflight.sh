#!/usr/bin/env bash
# Comprobaciones previas a la instalación.
set -euo pipefail

HOST="lenovo-v14"
DISK="/dev/nvme0n1"

red() { printf '\033[0;31m%s\033[0m\n' "$*"; }
green() { printf '\033[0;32m%s\033[0m\n' "$*"; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }

export NIX_CONFIG="experimental-features = nix-command flakes"

bold "==> Preflight"

if [[ ! -b "${DISK}" ]]; then
  red "ERROR: Disco ${DISK} no encontrado."
  exit 1
fi
green "    Disco ${DISK} OK"

if command -v mokutil >/dev/null 2>&1; then
  if mokutil --sb-state 2>/dev/null | grep -qi enabled; then
    red "ERROR: Secure Boot está activado. Desactívalo en BIOS (F2)."
    exit 1
  fi
  green "    Secure Boot desactivado"
fi

if ip link show | grep -q "state UP"; then
  green "    Red activa"
else
  red "AVISO: Sin red activa. Conecta Ethernet para descargar paquetes."
fi

if [[ ! -f flake.nix ]]; then
  red "ERROR: Ejecuta desde la raíz del repositorio."
  exit 1
fi

nix flake metadata ".#nixosConfigurations.${HOST}" >/dev/null 2>&1 \
  || nix eval ".#nixosConfigurations.${HOST}.config.system.build.toplevel.drvPath" >/dev/null

green "    Flake ${HOST} evalúa correctamente"
green "==> Preflight OK"
