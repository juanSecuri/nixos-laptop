# Troubleshooting

## Menú de arranque con GNOME y Plasma (ISO Graphical)

**Síntoma:** Al arrancar el USB ves 4 entradas (GNOME/Plasma × LTS/7.2).

**Causa:** Es la ISO gráfica de NixOS — solo elige el entorno del instalador en vivo.

**Fix:** Elige cualquiera (ej. GNOME LTS) o usa la **Minimal ISO** para una sola opción.

---

## Secure Boot

**Síntoma:** USB no arranca o kernel panic.

**Fix:** BIOS → Secure Boot → Disabled → F10 guardar.

```bash
mokutil --sb-state
```

---

## Wi-Fi no funciona en live USB

**Fix:** Usa Ethernet. El sistema instalado trae `linuxPackages_latest` + `linux-firmware` para RTL8852BE.

```bash
sudo dmesg | grep -i rtw89
nmcli device wifi list
```

---

## SDDM / Hyprland no aparece

```bash
sudo systemctl status display-manager
journalctl -u display-manager -b --no-pager | tail -50
```

TTY: `Ctrl + Alt + F3`, login, luego:

```bash
sudo nixos-rebuild switch --flake ~/nixos-laptop#lenovo-v14
```

---

## Waybar duplicado

```bash
pgrep -a waybar   # debe haber UN solo proceso
```

Si hay dos: `killall waybar && systemctl --user restart waybar`.

---

## SSH localhost (nixos-anywhere)

```bash
passwd root
systemctl start sshd
mkdir -p /root/.ssh && chmod 700 /root/.ssh
ssh-keygen -t ed25519 -N "" -f /root/.ssh/id_ed25519
cat /root/.ssh/id_ed25519.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
ssh root@127.0.0.1 echo OK
```

---

## Error de compilación (nombres de paquetes)

Dry-run en live USB:

```bash
cd /root/nixos-laptop
nix build .#nixosConfigurations.lenovo-v14.config.system.build.toplevel --dry-run
```

---

## Rollback

```bash
sudo nixos-rebuild switch --rollback
```

O en el menú de arranque: generación anterior en systemd-boot.

---

## Cursor no inicia

```bash
~/.local/share/cursor/cursor.AppImage --no-sandbox
```
