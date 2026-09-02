# nixos-laptop

Configuración declarativa de NixOS para **jloaiza10** — Lenovo V14 G4 ABP (Ryzen 7 7730U, 22 GB RAM).

| | |
|---|---|
| **Escritorio** | Hyprland · Quickshell · LY · Matugen · awww · Alacritty |
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
  core/                 # Hyprland, LY, paquetes, fuentes, portales
  home/                 # Quickshell, Hypr Lua, Alacritty, fe/Mixlr, Neovim
  hardware/             # AMD laptop, PipeWire, kernel
  boot/                 # systemd-boot, Plymouth
  dev/                  # Python, Node, Java, Docker, DB, CLI
  system/               # Red, locale, SSH
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
| `Super + T` | Terminal (Alacritty) |
| `Super + SUPER_L` | Launcher (Quickshell) |
| `Super + P` | Menú de apagado |
| `Super + E` | Archivos (Thunar) |
| `Super + W` | Navegador (Librewolf) |
| `Super + Shift + C` | Cursor IDE |
| `Super + Shift + B` | La Palabra del Señor (Mixlr) |

## Herramientas de desarrollo (system-wide)

Incluidas vía `modules/dev/` — Python 3.11, uv, ruff, Node 22, pnpm, Java 21, Docker, PostgreSQL 16, Supabase CLI, Azure CLI, gh, chromedriver, tesseract, y más.

```bash
projects          # cd ~/Projects
nix develop .#python
nix develop .#node
nix develop .#profit-catalyst
```

Cursor (AppImage): ver [docs/POST-INSTALL.md](docs/POST-INSTALL.md).

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
