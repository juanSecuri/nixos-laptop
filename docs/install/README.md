# Installation guide

Install **NixOS** on the Lenovo V14 G4 ABP using a **USB stick** and **Rufus** on Windows.

> **Why USB?** kexec from Debian fails on this laptop (black screen). The live USB installer is the supported path.

## Order of operations (~7 PM)

| Step | Doc | Where | Time |
|------|-----|-------|------|
| 0 | [Checklist](./00-checklist.md) | Before you start | 15 min |
| 1 | [Windows + Rufus](./01-windows-rufus.md) | Windows PC | 10 min |
| 2 | [Live installer](./02-live-installer.md) | Laptop from USB | 60–90 min |
| 3 | [Post-install](./03-post-install.md) | First NixOS boot | 30 min |

## Quick commands (live installer)

After booting the USB and opening a root terminal:

```bash
git clone https://github.com/juanSecuri/nixos-laptop.git /root/nixos-laptop
bash /root/nixos-laptop/scripts/install-from-usb.sh
```

## Requirements

- USB drive ≥ 4 GB (everything on it will be erased)
- Ethernet cable (Wi-Fi may not work until after install)
- **Secure Boot disabled** in BIOS
- Backup of `/home/jloaiza10` (install **wipes the whole disk**)

## Troubleshooting

See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md).
