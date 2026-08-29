#!/usr/bin/env bash
# DEPRECATED — kexec fails on Lenovo V14 G4 ABP (black screen on Debian).
# Use USB install instead: docs/install/README.md
set -euo pipefail

cat <<'EOF'

╔══════════════════════════════════════════════════════════════════╗
║  DEPRECATED: install-from-debian.sh                              ║
║                                                                  ║
║  kexec does NOT work on this laptop (black screen).              ║
║  Use the USB + Rufus method instead:                             ║
║                                                                  ║
║    docs/install/01-windows-rufus.md                              ║
║    docs/install/02-live-installer.md                             ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝

EOF

read -r -p "Continue with deprecated kexec install anyway? [y/N] " answer
if [[ "${answer}" != "y" && "${answer}" != "Y" ]]; then
  exit 1
fi

REPO="${1:-$HOME/nixos-laptop}"
HOST="lenovo-v14"
USER_NAME="${USER:-jloaiza10}"

echo "==> Preflight checks"

if ! grep -q CONFIG_KEXEC=y "/boot/config-$(uname -r)" 2>/dev/null; then
  echo "WARNING: CONFIG_KEXEC may not be enabled."
fi

if ! command -v kexec >/dev/null && [[ ! -x /usr/sbin/kexec ]]; then
  echo "ERROR: Install kexec-tools: sudo apt install kexec-tools cpio"
  exit 1
fi

if ! ssh -o BatchMode=yes -o ConnectTimeout=3 "${USER_NAME}@localhost" true 2>/dev/null; then
  echo "ERROR: Passwordless SSH to localhost required."
  exit 1
fi

if ! command -v nix >/dev/null; then
  echo "ERROR: Nix not installed."
  exit 1
fi

cd "$REPO"

nix build ".#nixosConfigurations.${HOST}.config.system.build.toplevel" --dry-run --impure

read -r -p "Type YES to continue (WILL ERASE DISK): " confirm
[[ "$confirm" == "YES" ]] || exit 1

nix run github:nix-community/nixos-anywhere -- \
  --flake ".#${HOST}" \
  --generate-hardware-config nixos-generate-config "./hosts/${HOST}/hardware-configuration.nix" \
  --target-host "${USER_NAME}@localhost" \
  --build-on local

echo "==> Done. Machine will reboot into NixOS."
