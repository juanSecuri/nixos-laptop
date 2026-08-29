# Pre-install checklist

Complete this **before** writing the USB or booting the installer.

## Hardware

- [ ] Laptop: **Lenovo V14 G4 ABP** (Ryzen 7 7730U)
- [ ] Disk target: **`/dev/nvme0n1`** (edit `hosts/lenovo-v14/disko.nix` if different)
- [ ] **Ethernet** cable to router
- [ ] USB stick **≥ 4 GB** (will be erased)

## BIOS (F2 or Del at power-on)

- [ ] **Secure Boot → Disabled** (required for NixOS installer)
- [ ] Boot mode: **UEFI** (not Legacy-only)
- [ ] Optional: set USB as first boot device, or use **F12** boot menu

## Backup

- [ ] Copy `/home/jloaiza10` to external drive or cloud
- [ ] Export browser bookmarks / passwords if needed
- [ ] Note Wi-Fi SSID and password (for after install)

## Repository (optional, recommended)

- [ ] Add your SSH public key in `hosts/lenovo-v14/default.nix` → `users.users.jloaiza10.openssh.authorizedKeys.keys`
- [ ] Push changes to GitHub so the live installer clones the latest config

```bash
# On Debian or Windows (with git), edit default.nix then:
git add hosts/lenovo-v14/default.nix
git commit -m "Add SSH key for post-install login"
git push
```

If you skip this, you can still log in with the **password you set** during install (or set one on first boot).

## Windows (Rufus)

- [ ] Download [Rufus](https://rufus.ie/)
- [ ] Download ISO (see [01-windows-rufus.md](./01-windows-rufus.md))

## What gets erased

The installer runs **disko** and repartitions **`/dev/nvme0n1`**:

| Partition | Size | Purpose |
|-----------|------|---------|
| ESP | 512 MiB | `/boot` |
| swap | 16 GiB | suspend |
| root | rest | btrfs subvolumes `@root`, `@home`, `@nix`, `@log` |

**Debian and all data on that disk will be lost.**

## Ready?

→ [01-windows-rufus.md](./01-windows-rufus.md)
