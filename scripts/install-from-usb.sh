#!/usr/bin/env bash
# Install NixOS on lenovo-v14 from any NixOS live USB (official or nix-community).
# Usage: bash scripts/install-from-usb.sh [repo-path]
set -euo pipefail

REPO="${1:-/root/nixos-laptop}"
HOST="lenovo-v14"
DISK="/dev/nvme0n1"
DISK_ROOT="${DISK_ROOT:-/dev/nvme0n1p2}"
DISK_SWAP="${DISK_SWAP:-/dev/nvme0n1p3}"
WORK=/mnt/debian

red() { printf '\033[0;31m%s\033[0m\n' "$*"; }
green() { printf '\033[0;32m%s\033[0m\n' "$*"; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }

bold "==> NixOS install: ${HOST}"
echo "    Repository: ${REPO}"
echo "    Target disk: ${DISK} (ALL DATA WILL BE ERASED)"
echo

if [[ ! -f /etc/os-release ]] || ! grep -qi nixos /etc/os-release; then
  red "ERROR: Run this from a NixOS live USB (as root)."
  exit 1
fi

if [[ "$(id -u)" -ne 0 ]]; then
  red "ERROR: Run as root."
  exit 1
fi

if [[ ! -d "${REPO}" ]]; then
  bold "==> Cloning repository..."
  git clone https://github.com/juanSecuri/nixos-laptop.git "${REPO}"
fi

cd "${REPO}"

bold "==> Disk workspace (store + temp on ${DISK_ROOT}, not RAM)"
umount "${WORK}" 2>/dev/null || true
mkdir -p "${WORK}"
mount -o rw "${DISK_ROOT}" "${WORK}"

mkdir -p "${WORK}/.nix-install/"{store,tmp,var,cache}
if ! mountpoint -q /nix/store 2>/dev/null || [[ "$(df /nix/store | tail -1 | awk '{print $1}')" == tmpfs* ]]; then
  mount --bind "${WORK}/.nix-install/store" /nix/store 2>/dev/null \
    || green "    Using existing /nix/store mount"
fi
export TMPDIR="${WORK}/.nix-install/tmp"
export NIX_STATE_DIR="${WORK}/.nix-install/var"
export XDG_CACHE_HOME="${WORK}/.nix-install/cache"
export NIX_BUILD_CORES=2
mkdir -p /root/nix-conf
cat > /root/nix-conf/nix.conf << 'EOF'
experimental-features = nix-command flakes
max-jobs = 2
cores = 2
EOF
export NIX_CONF_DIR=/root/nix-conf
export NIX_CONFIG=$'max-jobs = 2\ncores = 2'
green "    TMPDIR=${TMPDIR}"

bold "==> Swap"
swapon "${DISK_SWAP}" 2>/dev/null || true
if ! swapon --show | grep -q .; then
  SWAPFILE="${WORK}/.nix-install-swap"
  rm -f "${SWAPFILE}"
  fallocate -l 16G "${SWAPFILE}" \
    || dd if=/dev/zero of="${SWAPFILE}" bs=1M count=16384 status=progress
  chmod 600 "${SWAPFILE}"
  mkswap "${SWAPFILE}"
  swapon "${SWAPFILE}"
fi
free -h
df -h /nix/store "${WORK}" 2>/dev/null || df -h

if [[ -f scripts/preflight-installer.sh ]]; then
  bash scripts/preflight-installer.sh
fi

bold "==> SSH localhost (nixos-anywhere)"
mkdir -p /root/.ssh
chmod 700 /root/.ssh
if [[ ! -f /root/.ssh/id_ed25519 ]]; then
  ssh-keygen -t ed25519 -N "" -f /root/.ssh/id_ed25519
fi
grep -qF "$(cat /root/.ssh/id_ed25519.pub)" /root/.ssh/authorized_keys 2>/dev/null \
  || cat /root/.ssh/id_ed25519.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# Official minimal ISO: enable sshd if needed
if command -v systemctl >/dev/null; then
  systemctl start sshd 2>/dev/null || true
fi

if ! ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 \
  root@127.0.0.1 true 2>/dev/null; then
  red "ERROR: SSH to root@127.0.0.1 failed. Run: passwd root && systemctl start sshd"
  exit 1
fi
green "    SSH localhost OK"

bold "==> Dry-run"
nix build ".#nixosConfigurations.${HOST}.config.system.build.toplevel" --dry-run \
  --option max-jobs 2 --option cores 2

echo
red "WARNING: This will ERASE ${DISK} and install NixOS."
read -r -p "Type YES to continue: " confirm
if [[ "${confirm}" != "YES" ]]; then
  echo "Aborted."
  exit 1
fi

bold "==> Installing (mostly downloads, 45–90 min)"
nix run github:nix-community/nixos-anywhere -- \
  --flake ".#${HOST}" \
  --generate-hardware-config nixos-generate-config "./hosts/${HOST}/hardware-configuration.nix" \
  --target-host root@127.0.0.1 \
  --build-on local \
  --print-build-logs \
  --option max-jobs 2 \
  --option cores 2

green "==> Done. Reboot into NixOS (remove USB)."
green "    Post-install: docs/install/03-post-install.md"
