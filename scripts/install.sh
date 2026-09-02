#!/usr/bin/env bash
# Instala NixOS en lenovo-v14 desde USB live (ISO Minimal o Graphical).
# Uso: bash scripts/install.sh [ruta-del-repo]
set -euo pipefail

# Live ISO tools live under /run/current-system; keep PATH explicit for resilience.
export PATH="/run/current-system/sw/bin:/run/wrappers/bin:${PATH:-}"

REPO="${1:-/root/nixos-laptop}"
HOST="lenovo-v14"
DISK="/dev/nvme0n1"
ROOT_PART="/dev/disk/by-partlabel/disk-main-root"

red() { printf '\033[0;31m%s\033[0m\n' "$*"; }
green() { printf '\033[0;32m%s\033[0m\n' "$*"; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }

export NIX_CONFIG="experimental-features = nix-command flakes
require-sigs = false
trusted-users = root
substituters = https://cache.nixos.org
trusted-substituters = https://cache.nixos.org"

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
git clean -fd 2>/dev/null || true

if ! grep -q 'doDoc = false' hosts/lenovo-v14/default.nix; then
  red "ERROR: Repo desactualizado. Sin conexión a GitHub?"
  exit 1
fi
green "    Config actualizada (nixos-24.11)"

bold "==> Liberar espacio en live USB"
swapoff /swapfile 2>/dev/null || true
rm -f /swapfile 2>/dev/null || true
umount -R /mnt 2>/dev/null || true
nix-collect-garbage -d 2>/dev/null || true
df -h / /nix
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
  exit 1
fi
green "    SSH localhost OK"

bold "==> Dry-run (verifica que el flake evalúa)"
nix build ".#nixosConfigurations.${HOST}.config.system.build.toplevel" \
  --dry-run \
  --option max-jobs 1 \
  --option cores 2

echo
red "ADVERTENCIA: Esto BORRARÁ ${DISK} e instalará NixOS + Hyprland."
read -r -p "Escribe YES para continuar: " confirm
if [[ "${confirm}" != "YES" ]]; then
  echo "Cancelado."
  exit 1
fi

# Overlay store: USB store stays readable (lower), new builds go to NVMe (upper).
# Plain bind-mounting an empty NVMe store breaks rm/nix on the live ISO.
use_nvme_store() {
  bold "==> Store overlay: USB (lectura) + NVMe (escritura para compilar)"
  mkdir -p /mnt/nix
  umount /mnt/nix 2>/dev/null || true
  mount -o subvol=@nix "${ROOT_PART}" /mnt/nix

  local upper="/mnt/nix/store-upper"
  local work="/mnt/nix/store-work"
  local merged="/mnt/nix/store-merged"
  mkdir -p "${upper}" "${work}" "${merged}"

  mount -t overlay overlay \
    -o "lowerdir=/nix/store,upperdir=${upper},workdir=${work}" \
    "${merged}"

  systemctl stop nix-daemon 2>/dev/null || true
  umount /nix/store 2>/dev/null || true
  mount --bind "${merged}" /nix/store
  systemctl start nix-daemon 2>/dev/null || true

  export TMPDIR="/mnt/nix/tmp"
  mkdir -p "${TMPDIR}"

  export PATH="/run/current-system/sw/bin:/run/wrappers/bin:${PATH:-}"

  if ! /run/current-system/sw/bin/test -x /run/current-system/sw/bin/rm; then
    red "ERROR: overlay store falló — reinicia el live USB y reintenta."
    exit 1
  fi

  df -h /nix/store /mnt/nix 2>/dev/null || true
  green "    Overlay activo: compilación en NVMe, herramientas del USB intactas"
}

bold "==> Particionar disco (disko)"
nix run github:nix-community/disko -- \
  --mode disko \
  --flake ".#${HOST}"

use_nvme_store

bold "==> Instalando (45–90 min, Ethernet conectado)"
bold "    build-on local + disko-mode mount (sin reparticionar, sin error de firmas)"
nix run github:nix-community/nixos-anywhere -- \
  --flake ".#${HOST}" \
  --generate-hardware-config nixos-generate-config "./hosts/${HOST}/hardware-configuration.nix" \
  --target-host root@127.0.0.1 \
  --build-on local \
  --disko-mode mount \
  --print-build-logs \
  --option require-sigs false \
  --option trusted-users root \
  --option max-jobs 1 \
  --option cores 2

green "==> Listo. Reinicia y saca el USB."
green "    Post-instalación: docs/POST-INSTALL.md"
