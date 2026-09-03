# Instalación — Fedora + Hyprland profesional

Setup para **Lenovo V14** basado en:

- [JaKooLit/Fedora-Hyprland](https://github.com/JaKooLit/Fedora-Hyprland) — instalador Hyprland
- [mylinuxforwork/hyprland-starter](https://github.com/mylinuxforwork/hyprland-starter) — patrones modulares

## Requisitos

1. **Fedora 41+** instalado (Workstation, KDE spin, o minimal)
2. Usuario normal con `sudo`
3. Internet estable
4. Actualizar antes: `sudo dnf upgrade -y && sudo reboot`

## Instalación en 1 comando

```bash
git clone https://github.com/juanSecuri/nixos-laptop.git ~/fedora-setup
cd ~/fedora-setup
chmod +x install.sh scripts/*.sh
./install.sh
sudo reboot
```

## Qué instala

### Escritorio (JaKooLit)
- Hyprland, Waybar, Rofi, Kitty, SDDM
- Thunar, Bluetooth, portales Wayland
- **Sin:** Pokemon terminal, AGS, Quickshell, tema SDDM flashy

### Herramientas dev (`scripts/dev-tools.sh`)
- Git, gh, Docker, Python, Node, Java 21
- VS Code, Wireshark, LibreOffice, Firefox
- uv, pnpm, Supabase CLI, Azure CLI
- Cisco Packet Tracer (si tienes el `.deb` en `~/Downloads/`)

### Fe (`scripts/faith.sh`)
- `SUPER + Shift + B` → Mixlr (La Palabra del Señor)
- `SUPER + Shift + Y` → Biblia YouVersion

### Cursor (`scripts/cursor.sh`)
- `SUPER + Shift + C` → Cursor IDE

## Atajos Hyprland

| Atajo | Acción |
|-------|--------|
| `SUPER + H` | Ayuda / keybinds |
| `SUPER + Return` | Terminal |
| `SUPER + R` | Launcher |
| `SUPER + E` | Archivos |
| `SUPER + Shift + C` | Cursor |
| `SUPER + Shift + B` | Mixlr |
| `SUPER + Shift + P` | ~/Projects |

## Personalizar

Edita archivos en `~/.config/hypr/UserConfigs/`:

```bash
nano ~/.config/hypr/UserConfigs/UserDecorations.conf
nano ~/.config/hypr/UserConfigs/UserKeybinds.conf
hyprctl reload
```

## Packet Tracer

1. Descarga el `.deb` desde [NetAcad](https://www.netacad.com/)
2. Guárdalo en `~/Downloads/PacketTracer_*.deb`
3. Vuelve a correr: `bash scripts/dev-tools.sh`

## Problemas comunes

| Problema | Solución |
|----------|----------|
| Hyprland no inicia | TTY → `Hyprland` (H mayúscula) |
| Rofi pixelado | `sudo dnf swap rofi rofi-wayland` |
| Docker permission | `sudo usermod -aG docker $USER` + logout |
| Waybar sin workspaces | Fedora 40+ requerido |

## Desinstalar Hyprland

```bash
cd ~/Fedora-Hyprland && ./uninstall.sh
```
