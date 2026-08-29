#!/usr/bin/env bash
# Preflight checks on the NixOS live USB before install.
set -euo pipefail

REPO="${1:-/root/nixos-laptop}"
HOST="lenovo-v14"
DISK="/dev/nvme0n1"

errors=0
warn() { printf '\033[0;33mWARN:\033[0m %s\n' "$*"; }
ok() { printf '\033[0;32mOK:\033[0m %s\n' "$*"; }
fail() { printf '\033[0;31mERROR:\033[0m %s\n' "$*"; errors=$((errors + 1)); }

echo "==> Preflight: ${HOST}"

if [[ ! -f /etc/os-release ]] || ! grep -qi nixos /etc/os-release; then
  fail "Not running NixOS live environment"
else
  ok "NixOS live environment"
fi

if [[ "$(id -u)" -ne 0 ]]; then
  fail "Not running as root — use: sudo -i"
else
  ok "Running as root"
fi

if command -v nix >/dev/null; then
  ok "nix $(nix --version | awk '{print $2}')"
else
  fail "nix command not found"
fi

if [[ -b "${DISK}" ]]; then
  ok "Target disk ${DISK} exists"
else
  fail "Target disk ${DISK} not found — edit disko.nix if your NVMe differs"
fi

if ip link show enp1s0 2>/dev/null | grep -q "state UP"; then
  ok "Ethernet enp1s0 is up"
elif ip link show enp1s0 2>/dev/null | grep -q "state"; then
  warn "Ethernet enp1s0 present but not UP — plug in cable"
else
  warn "enp1s0 not found — Wi-Fi-only install is harder on live ISO"
fi

if command -v mokutil >/dev/null; then
  if mokutil --sb-state 2>/dev/null | grep -qi disabled; then
    ok "Secure Boot disabled"
  else
    warn "Secure Boot may be enabled — disable in BIOS before install"
  fi
fi

if [[ -d "${REPO}" ]]; then
  ok "Repository at ${REPO}"
  if [[ -f "${REPO}/flake.nix" ]]; then
    ok "flake.nix present"
  else
    fail "flake.nix missing in ${REPO}"
  fi
else
  warn "Repository not cloned yet — install script will clone it"
fi

if [[ "${errors}" -gt 0 ]]; then
  echo
  fail "${errors} error(s) — fix before installing"
  exit 1
fi

echo
ok "Preflight passed"
exit 0
