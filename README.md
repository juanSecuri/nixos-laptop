# nixos-laptop

Configuración declarativa de NixOS para **jloaiza10** — Lenovo V14 G4 ABP (Ryzen 7 7730U, 22 GB RAM).

| | |
|---|---|
| **Escritorio** | Hyprland · Catppuccin Mocha · SDDM · Waybar · Rofi |
| **Desarrollo** | Python 3.11 · Node 22 · Java 21 · Docker · Supabase · Azure · gh |
| **Fe / audio** | Mixlr (La Palabra del Señor) · Biblia YouVersion · Firefox · mpv |
| **Instalación** | USB Minimal ISO → `bash scripts/install.sh` |
| **Flake** | `#lenovo-v14` |

## Instalación rápida

Guía completa: [docs/INSTALL.md](docs/INSTALL.md)

```bash
git clone https://github.com/juanSecuri/nixos-laptop.git /root/nixos-laptop
bash /root/nixos-laptop/scripts/install.sh
```

## Estructura

```
flake.nix
hosts/lenovo-v14/       # Host, disko, hardware-config
modules/
  hardware/             # AMD laptop, PipeWire, kernel
  boot/                 # systemd-boot, Plymouth
  desktop/              # Hyprland, SDDM Catppuccin, fonts, portals
  dev/                  # Python, Node, Java, Docker, DB, CLI
  system/               # Red, locale, SSH
home/jloaiza10/         # Hyprland, Waybar, Kitty, fe/Mixlr, Cursor
scripts/                # install.sh, preflight.sh
docs/                   # INSTALL, POST-INSTALL, TROUBLESHOOTING
```

Hardware: [docs/hardware/lenovo-v14.md](docs/hardware/lenovo-v14.md)

## Uso diario

```bash
rebuild    # sudo nixos-rebuild switch --flake ~/nixos-laptop#lenovo-v14
update     # nix flake update && rebuild
rollback   # revertir última generación
```

| Atajo | Acción |
|-------|--------|
| `Super + Return` | Terminal |
| `Super + R` | Apps |
| `Super + E` | Archivos |
| `Super + Shift + B` | La Palabra del Señor (Mixlr) |

## Dev shells

```bash
nix develop .#python
nix develop .#node
nix develop .#profit-catalyst
```

## Disco

| Partición | Tamaño | Montaje |
|-----------|--------|---------|
| ESP | 512 MiB | `/boot` |
| swap | 16 GiB | — |
| btrfs | resto | `/`, `/home`, `/nix`, `/var/log` |

## Antes de instalar

1. Backup de `/home/jloaiza10`
2. Secure Boot desactivado
3. Ethernet conectado
4. Opcional: clave SSH en `hosts/lenovo-v14/default.nix`
