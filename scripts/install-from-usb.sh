#!/usr/bin/env bash
# Install NixOS on lenovo-v14 from the nix-community live USB installer.
# Usage: bash scripts/install-from-usb.sh [repo-path]
set -euo pipefail

REPO="${1:-/root/nixos-laptop}"
HOST="lenovo-v14"
DISK="/dev/nvme0n1"

red() { printf '\033[0;31m%s\033[0m\n' "$*"; }
green() { printf '\033[0;32m%s\033[0m\n' "$*"; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }

bold "==> NixOS install: ${HOST}"
echo "    Repository: ${REPO}"
echo "    Target disk: ${DISK} (ALL DATA WILL BE ERASED)"
echo

if [[ ! -f /etc/os-release ]] || ! grep -qi nixos /etc/os-release; then
  red "ERROR: Run this script from the NixOS live USB installer (as root)."
  red "       See docs/install/02-live-installer.md"
  exit 1
fi

if [[ "$(id -u)" -ne 0 ]]; then
  red "ERROR: Run as root (sudo -i)."
  exit 1
fi

if [[ ! -d "${REPO}" ]]; then
  bold "==> Cloning repository..."
  git clone https://github.com/juanSecuri/nixos-laptop.git "${REPO}"
fi

cd "${REPO}"

if [[ -f scripts/preflight-installer.sh ]]; then
  bash scripts/preflight-installer.sh
fi

bold "==> Configuring root SSH for localhost (nixos-anywhere)"
mkdir -p /root/.ssh
chmod 700 /root/.ssh
if [[ ! -f /root/.ssh/id_ed25519 ]]; then
  ssh-keygen -t ed25519 -N "" -f /root/.ssh/id_ed25519
fi
grep -qF "$(cat /root/.ssh/id_ed25519.pub)" /root/.ssh/authorized_keys 2>/dev/null \
  || cat /root/.ssh/id_ed25519.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

if ! ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 \
  root@127.0.0.1 true 2>/dev/null; then
  red "ERROR: Passwordless SSH to root@127.0.0.1 failed."
  exit 1
fi
green "    SSH localhost OK"

bold "==> Evaluating configuration (dry-run)"
nix build ".#nixosConfigurations.${HOST}.config.system.build.toplevel" --dry-run

echo
red "WARNING: This will ERASE ${DISK} and install NixOS."
read -r -p "Type YES to continue: " confirm
if [[ "${confirm}" != "YES" ]]; then
  echo "Aborted."
  exit 1
fi

bold "==> Installing via nixos-anywhere (45–90 min)"
nix run github:nix-community/nixos-anywhere -- \
  --flake ".#${HOST}" \
  --generate-hardware-config nixos-generate-config "./hosts/${HOST}/hardware-configuration.nix" \
  --target-host root@127.0.0.1 \
  --build-on local \
  --print-build-logs

green "==> Installation complete. The system will reboot into NixOS."
green "    Next: docs/install/03-post-install.md"
