# Lenovo V14 G4 ABP

| Spec | Value |
|------|--------|
| Model | 82YX — Lenovo V14 G4 ABP |
| CPU | AMD Ryzen 7 7730U (8C/16T) |
| RAM | 22 GB |
| Disk | NVMe ~446 GB (`/dev/nvme0n1`) |
| GPU | AMD Barcelo (integrated) |
| Wi-Fi | Realtek RTL8852BE (rtw89) |
| Ethernet | Realtek (`enp1s0`) |

## NixOS modules used

- `modules/hardware/amd-laptop.nix` — AMDGPU, firmware, PipeWire, power
- `nixos-hardware` — `common-cpu-amd`, `common-pc-laptop`, `common-gpu-amd`
- `hosts/lenovo-v14/disko.nix` — GPT + btrfs layout

## BIOS notes

- **Secure Boot:** must be **disabled** for installer and NixOS boot
- **Boot menu:** F12
- **Setup:** F2

## Known issues

| Issue | Status |
|-------|--------|
| kexec from Debian | **Broken** — use USB install |
| Wi-Fi on first boot | Use Ethernet; Wi-Fi after `nixos-rebuild` |
| Suspend / lid close | Configured via `logind` → suspend |
