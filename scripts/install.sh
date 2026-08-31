#!/usr/bin/env bash
# Instala NixOS en lenovo-v14 desde USB live (ISO Minimal o Graphical).
# Uso: bash scripts/install.sh [ruta-del-repo]
set -euo pipefail

REPO="${1:-/root/nixos-laptop}"
HOST="lenovo-v14"
DISK="/dev/nvme0n1"

red() { printf '\033[0;31m%s\033[0m\n' "$*"; }
green() { printf '\033[0;32m%s\033[0m\n' "$*"; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }

# Live ISO may not enable flakes/nix-command by default
export NIX_CONFIG="experimental-features = nix-command flakes"

bold "==> Instalación NixOS: ${HOST}"
echo "    Repo: ${REPO}"
echo "    Disco: ${DISK} (SE BORRA TODO)"
echo

if [[ ! -f /etc/os-release ]] || ! grep -qi nixos /etc/os-release; then
  red "ERROR: Ejecuta esto desde un USB live de NixOS (como root)."
  exit 1
fi

if [[ "$(id -u)" -ne 0 ]]; then
  red "ERROR: Ejecuta como root."
  exit 1
fi

if [[ ! -d "${REPO}" ]]; then
  bold "==> Clonando repositorio..."
  git clone https://github.com/juanSecuri/nixos-laptop.git "${REPO}"
fi

cd "${REPO}"
git fetch origin 2>/dev/null && git reset --hard origin/main 2>/dev/null || true

bold "==> Swap temporal (evita quedarse sin RAM durante la compilación)"
if ! swapon --show | grep -q .; then
  SWAPFILE="/swapfile"
  rm -f "${SWAPFILE}" 2>/dev/null || true

  # Live ISO root is small — use 4G max (22GB RAM laptop needs little extra swap)
  SWAP_GB=4
  AVAIL_KB="$(df --output=avail / | tail -1 | tr -d ' ')"
  if [[ -n "${AVAIL_KB}" && "${AVAIL_KB}" -lt 5000000 ]]; then
    SWAP_GB=2
  fi

  bold "    Creando swap de ${SWAP_GB}G en ${SWAPFILE}"
  fallocate -l "${SWAP_GB}G" "${SWAPFILE}" 2>/dev/null \
    || dd if=/dev/zero of="${SWAPFILE}" bs=1M count=$((SWAP_GB * 1024)) status=progress
  chmod 600 "${SWAPFILE}"
  mkswap -f "${SWAPFILE}" 2>/dev/null || mkswap "${SWAPFILE}"
  swapon "${SWAPFILE}" 2>/dev/null || bold "    AVISO: sin swap extra — continuando con RAM del live USB"
fi
free -h

if [[ -f scripts/preflight.sh ]]; then
  bash scripts/preflight.sh
fi

bold "==> SSH localhost (requerido por nixos-anywhere)"
mkdir -p /root/.ssh
chmod 700 /root/.ssh
if [[ ! -f /root/.ssh/id_ed25519 ]]; then
  ssh-keygen -t ed25519 -N "" -f /root/.ssh/id_ed25519
fi
grep -qF "$(cat /root/.ssh/id_ed25519.pub)" /root/.ssh/authorized_keys 2>/dev/null \
  || cat /root/.ssh/id_ed25519.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

systemctl start sshd 2>/dev/null || true

if ! ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 \
  root@127.0.0.1 true 2>/dev/null; then
  red "ERROR: SSH a root@127.0.0.1 falló."
  red "En ISO Minimal: passwd root && systemctl start sshd"
  exit 1
fi
green "    SSH localhost OK"

bold "==> Dry-run (verifica que el flake evalúa)"
nix build ".#nixosConfigurations.${HOST}.config.system.build.toplevel" \
  --dry-run \
  --option max-jobs 2 \
  --option cores 2

echo
red "ADVERTENCIA: Esto BORRARÁ ${DISK} e instalará NixOS + Hyprland."
read -r -p "Escribe YES para continuar: " confirm
if [[ "${confirm}" != "YES" ]]; then
  echo "Cancelado."
  exit 1
fi

bold "==> Instalando (45–90 min, Ethernet conectado)"
nix run github:nix-community/nixos-anywhere -- \
  --flake ".#${HOST}" \
  --generate-hardware-config nixos-generate-config "./hosts/${HOST}/hardware-configuration.nix" \
  --target-host root@127.0.0.1 \
  --build-on local \
  --print-build-logs \
  --option max-jobs 2 \
  --option cores 2

green "==> Listo. Reinicia y saca el USB."
green "    Post-instalación: docs/POST-INSTALL.md"
