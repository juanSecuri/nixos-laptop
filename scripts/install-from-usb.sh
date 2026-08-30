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

export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:${PATH:-}"

systemctl_cmd() {
  if command -v systemctl >/dev/null; then
    systemctl "$@"
  elif [[ -x /run/current-system/sw/bin/systemctl ]]; then
    /run/current-system/sw/bin/systemctl "$@"
  else
    return 1
  fi
}

stop_nix_daemon() {
  systemctl_cmd stop nix-daemon nix-daemon.socket 2>/dev/null \
    || pkill -9 nix-daemon 2>/dev/null \
    || true
}

start_nix_daemon() {
  pkill -9 nix-daemon 2>/dev/null || true
  if [[ -n "${NIX_CONF_DIR:-}" ]] && command -v nix-daemon >/dev/null; then
    NIX_CONF_DIR="${NIX_CONF_DIR}" nix-daemon &
    sleep 2
    return 0
  fi
  if systemctl_cmd start nix-daemon.socket nix-daemon 2>/dev/null; then
    return 0
  fi
  if command -v nix-daemon >/dev/null; then
    nix-daemon &
    sleep 2
    return 0
  fi
  return 1
}

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
if ! git fetch origin 2>/dev/null; then
  bold "==> git fetch failed — recloning repository"
  rm -rf "${REPO}"
  git clone https://github.com/juanSecuri/nixos-laptop.git "${REPO}"
  cd "${REPO}"
fi
git reset --hard origin/main 2>/dev/null || true
rm -f /root/.local/share/nix/trusted-settings.json
rm -f /root/.config/nix/nix.conf

bold "==> Disk workspace (store + temp on ${DISK_ROOT}, not RAM)"
umount "${WORK}" 2>/dev/null || true
mkdir -p "${WORK}"
mount -o rw "${DISK_ROOT}" "${WORK}"
rm -rf "${WORK}/.nix-install"

STORE="${WORK}/.nix-install/store"
mkdir -p "${STORE}" "${WORK}/.nix-install/"{tmp,var,cache}
export TMPDIR="${WORK}/.nix-install/tmp"
export NIX_STATE_DIR="${WORK}/.nix-install/var"
export XDG_CACHE_HOME="${WORK}/.nix-install/cache"
export NIX_BUILD_CORES=2

stop_nix_daemon

# NEVER bind-mount over /nix/store on live ISO — it hides the running system's binaries.
mkdir -p /root/nix-conf
cat > /root/nix-conf/nix.conf << EOF
experimental-features = nix-command flakes
max-jobs = 2
cores = 2
store = ${STORE}
EOF
export NIX_CONF_DIR=/root/nix-conf
export NIX_CONFIG=$'max-jobs = 2\ncores = 2'

cat > /root/.profile << EOF
export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:\$PATH"
export NIX_CONF_DIR=/root/nix-conf
export TMPDIR=${TMPDIR}
export NIX_STATE_DIR=${NIX_STATE_DIR}
export XDG_CACHE_HOME=${XDG_CACHE_HOME}
EOF
cp /root/.profile /root/.bashrc

start_nix_daemon || red "ERROR: could not start nix-daemon"
sleep 2

AVAIL="$(df --output=avail -B1 "${WORK}" | tail -1)"
if [[ "${AVAIL}" -lt 50000000000 ]]; then
  red "ERROR: Need at least 50 GiB free on ${DISK_ROOT}"
  df -h "${WORK}"
  exit 1
fi
green "    store=${STORE} (via nix.conf, /nix/store untouched)"
green "    TMPDIR=${TMPDIR}"
df -h "${STORE}" "${WORK}"

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
df -h "${STORE}" "${WORK}" 2>/dev/null || df -h

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
if systemctl_cmd start sshd 2>/dev/null; then
  :
elif [[ -x /run/current-system/sw/bin/sshd ]]; then
  /run/current-system/sw/bin/sshd 2>/dev/null || true
fi

if ! ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 \
  root@127.0.0.1 true 2>/dev/null; then
  red "ERROR: SSH to root@127.0.0.1 failed. Run: passwd root && systemctl start sshd"
  exit 1
fi
green "    SSH localhost OK"

NIX_STORE_OPTS=(--store "${STORE}")
NIX_CACHE_OPTS=(
  --option substituters "https://cache.nixos.org"
  --option trusted-public-keys "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
)

bold "==> Dry-run"
nix build ".#nixosConfigurations.${HOST}.config.system.build.toplevel" --dry-run \
  --option max-jobs 2 --option cores 2 \
  "${NIX_STORE_OPTS[@]}" "${NIX_CACHE_OPTS[@]}"

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
  --option cores 2 \
  "${NIX_CACHE_OPTS[@]}"

green "==> Done. Reboot into NixOS (remove USB)."
green "    Post-install: docs/install/03-post-install.md"
