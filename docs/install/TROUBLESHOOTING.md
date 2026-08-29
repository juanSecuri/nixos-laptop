# Troubleshooting

## kexec / Debian install (deprecated)

**Symptom:** Black screen immediately after `nixos-anywhere` or `/root/kexec/run` on Debian.

**Cause:** kexec fails on Lenovo V14 G4 ABP with Debian 6.12 + this firmware.

**Fix:** Use the **USB installer** path ([README](./README.md)). Do not use `scripts/install-from-debian.sh`.

---

## Secure Boot

**Symptom:** USB boots to error, or installer/kernel panic.

**Fix:** BIOS → **Secure Boot → Disabled** → save → retry.

Check from Linux:

```bash
mokutil --sb-state
```

---

## Wi-Fi not working after install

**Fix:** Use Ethernet for first boot and rebuild. Config already sets `linuxPackages_latest` and `linux-firmware` for RTL8852BE.

```bash
sudo dmesg | grep -i rtw89
nmcli device wifi list
```

---

## SDDM / Hyprland not showing

```bash
sudo systemctl status display-manager
journalctl -u display-manager -b --no-pager | tail -50
```

Try tty: `Ctrl + Alt + F3`, login, then `sudo nixos-rebuild switch --flake ~/nixos-laptop#lenovo-v14`.

---

## nixos-anywhere SSH errors (live USB)

```bash
mkdir -p /root/.ssh && chmod 700 /root/.ssh
ssh-keygen -t ed25519 -N "" -f /root/.ssh/id_ed25519
cat /root/.ssh/id_ed25519.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
ssh root@127.0.0.1 echo OK
```

---

## Build errors (deprecated package names)

Ensure you have the latest `main` from GitHub. Common fixes already in this repo:

- `poppler-utils` (not `poppler_utils`)
- `qt6Packages.qt6ct` (not `qt6ct`)
- `rofi` (not `rofi-wayland`)
- `nerd-fonts.jetbrains-mono` (not `nerdfonts.override`)
- No separate `rtw89-firmware` package

Dry-run on live installer:

```bash
cd /root/nixos-laptop
nix build .#nixosConfigurations.lenovo-v14.config.system.build.toplevel --dry-run
```

---

## Rollback

```bash
sudo nixos-rebuild switch --rollback
# or from boot menu: select previous generation in systemd-boot
```

---

## Cursor AppImage

If Cursor fails to start:

```bash
~/.local/share/cursor/cursor.AppImage --no-sandbox
```
