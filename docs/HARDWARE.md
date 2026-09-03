# Lenovo V14 G4 ABP — Ryzen 7 7730U, 22 GB RAM, NVMe

| | |
|---|---|
| **CPU** | AMD Ryzen 7 7730U |
| **RAM** | 22 GB |
| **GPU** | AMD integrated (Radeon Vega) |
| **Disco** | NVMe ~446 GB |
| **WiFi** | Realtek / Intel (NetworkManager) |

## Recomendaciones Fedora

- **Fedora 41 o 42** Workstation o Everything netinstall
- Secure Boot: desactivado (o firmar módulos si usas NVIDIA — no aplica aquí)
- Particiones sugeridas:
  - `/boot/efi` — 512 MiB
  - `/` — 80–100 GiB ext4 o btrfs
  - `/home` — resto
  - swap — 8–16 GiB (opcional con 22 GB RAM)

## Post-instalación

```bash
git clone https://github.com/juanSecuri/nixos-laptop.git ~/fedora-setup
cd ~/fedora-setup
chmod +x install.sh scripts/*.sh
./install.sh
sudo reboot
```
