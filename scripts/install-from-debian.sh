#!/usr/bin/env bash
# Run from Debian before nixos-anywhere. Requires Ethernet + backup.
set -euo pipefail

REPO="${1:-$HOME/nixos-laptop}"
HOST="lenovo-v14"
USER_NAME="${USER:-jloaiza10}"

echo "==> Preflight checks"

if ! grep -q CONFIG_KEXEC=y "/boot/config-$(uname -r)" 2>/dev/null; then
  echo "WARNING: CONFIG_KEXEC may not be enabled. kexec might fail."
fi

if ! ssh -o BatchMode=yes -o ConnectTimeout=3 "${USER_NAME}@localhost" true 2>/dev/null; then
  echo "ERROR: Passwordless SSH to localhost required."
  echo "  ssh-keygen -t ed25519 && cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys"
  exit 1
fi

if ! command -v nix >/dev/null; then
  echo "ERROR: Nix not installed. See README.md Phase 0."
  exit 1
fi

cd "$REPO"

echo "==> Building flake (dry-run)"
nix flake check --no-build 2>/dev/null || nix build .#nixosConfigurations.${HOST}.config.system.build.toplevel --dry-run

echo "==> Installing NixOS via nixos-anywhere (WILL ERASE DISK)"
read -r -p "Type YES to continue: " confirm
if [[ "$confirm" != "YES" ]]; then
  echo "Aborted."
  exit 1
fi

nix run github:nix-community/nixos-anywhere -- \
  --flake ".#${HOST}" \
  --generate-hardware-config nixos-generate-config "./hosts/${HOST}/hardware-configuration.nix" \
  --target-host "${USER_NAME}@localhost" \
  --build-on local

echo "==> Done. Machine will reboot into NixOS."
