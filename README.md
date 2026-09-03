# fedora-hyprland-laptop

Configuración profesional **Fedora + Hyprland** para Lenovo V14 G4 ABP (jloaiza10).

| | |
|---|---|
| **Base** | Fedora 41/42 |
| **Escritorio** | Hyprland · Waybar · Rofi · SDDM · Kitty |
| **Instalador** | [JaKooLit/Fedora-Hyprland](https://github.com/JaKooLit/Fedora-Hyprland) |
| **Dotfiles** | Overrides modulares (estilo [ML4W](https://github.com/mylinuxforwork/hyprland-starter)) |
| **Dev** | Cursor, VS Code, Docker, Python, Node, Java, Wireshark, Packet Tracer |
| **Fe** | Mixlr · Biblia YouVersion |

> **Nota:** Este repo antes era NixOS. Ahora es setup Fedora. Más estable, sin flakes ni rebuilds.

## Instalación rápida

```bash
git clone https://github.com/juanSecuri/nixos-laptop.git ~/fedora-setup
cd ~/fedora-setup
chmod +x install.sh scripts/*.sh
./install.sh
sudo reboot
```

Guía completa: [docs/INSTALL.md](docs/INSTALL.md)

## Estructura

```
install.sh              # Orquestador principal
preset.sh               # Preset profesional para JaKooLit (sin pokemon/AGS)
scripts/
  apply-dotfiles.sh     # Overrides sobrios
  dev-tools.sh          # Herramientas de desarrollo
  faith.sh              # Mixlr + Biblia
  cursor.sh             # Cursor IDE
dotfiles/hypr/UserConfigs/  # Decoraciones, keybinds, env
assets/wallpapers/      # Wallpaper
docs/                   # Guías
```

## Atajos

| Atajo | Acción |
|-------|--------|
| `SUPER + H` | Ayuda Hyprland |
| `SUPER + Shift + C` | Cursor |
| `SUPER + Shift + B` | La Palabra del Señor (Mixlr) |
| `SUPER + Shift + Y` | Biblia |
| `SUPER + Shift + P` | ~/Projects |

## Hardware

[docs/HARDWARE.md](docs/HARDWARE.md)

## Referencias

- https://github.com/JaKooLit/Fedora-Hyprland
- https://github.com/mylinuxforwork/hyprland-starter
- https://github.com/JaKooLit/Hyprland-Dots
