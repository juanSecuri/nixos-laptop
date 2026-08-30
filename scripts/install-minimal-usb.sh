#!/usr/bin/env bash
# Phase 1: minimal NixOS install from official live USB — NO GitHub, NO flake.
# Phase 2 (after reboot): clone repo and run nixos-rebuild switch --flake .#lenovo-v14
set -euo pipefail

DISK="/dev/nvme0n1"
HOST="lenovo-v14"
USER="jloaiza10"

export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:${PATH:-}"

red() { printf '\033[0;31m%s\033[0m\n' "$*"; }
green() { printf '\033[0;32m%s\033[0m\n' "$*"; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }

if [[ "$(id -u)" -ne 0 ]]; then
  red "Run as root: sudo -i"
  exit 1
fi

bold "==> Minimal NixOS install (phase 1)"
echo "    Disk: ${DISK} — ALL DATA WILL BE ERASED"
echo "    No GitHub during install. Full config comes after reboot."
echo
red "Type YES to partition and install: "
read -r confirm
[[ "${confirm}" == "YES" ]] || exit 1

bold "==> Partitioning"
parted -s "${DISK}" mklabel gpt
parted -s "${DISK}" mkpart ESP fat32 1MiB 512MiB
parted -s "${DISK}" set 1 esp on
parted -s "${DISK}" mkpart swap linux-swap 512MiB 17408MiB
parted -s "${DISK}" mkpart root ext4 17408MiB 100%

mkfs.fat -F32 -n BOOT "${DISK}p1"
mkswap -L swap "${DISK}p2"
mkfs.ext4 -F -L nixos "${DISK}p3"

bold "==> Mount"
mount "${DISK}p3" /mnt
mkdir -p /mnt/boot
mount "${DISK}p1" /mnt/boot
swapon "${DISK}p2"

bold "==> Generate hardware config"
nixos-generate-config --root /mnt

bold "==> Write minimal configuration.nix"
cat > /mnt/etc/nixos/configuration.nix << 'EOF'
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lenovo-v14";
  networking.networkManager.enable = true;

  time.timeZone = "America/Bogota";

  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.openssh.enable = true;

  users.users.jloaiza10 = {
    isNormalUser = true;
    description = "Juan";
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "nixos123";
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];

  system.stateVersion = "25.05";
}
EOF

bold "==> Installing (20–40 min, mostly downloads)"
nixos-install --no-root-passwd --option extra-experimental-features "nix-command flakes"

green "==> Phase 1 done."
echo
bold "Next steps:"
echo "  1. Remove USB"
echo "  2. reboot"
echo "  3. Login: ${USER} / password: nixos123"
echo "  4. Then run phase 2 — see docs/install/FASE-2-FLAKE-ES.md"
