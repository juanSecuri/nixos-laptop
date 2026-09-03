# fedora-hyprland-laptop

Setup **Fedora + Hyprland** profesional para Lenovo V14 — dev, sobrio, para el Señor.

| | |
|---|---|
| **Base** | Fedora 41/42/44 |
| **Dotfiles** | [ML4W hyprland-starter](https://github.com/mylinuxforwork/hyprland-starter) |
| **Sin** | JaKooLit, pokemon, anime, quickshell, matrix |
| **Con** | Tema ML4W oficial, Mixlr, Biblia, Cursor, dev tools |

## Instalación nueva (Fedora recién instalado)

```bash
git clone https://github.com/juanSecuri/nixos-laptop.git ~/fedora-setup
cd ~/fedora-setup
chmod +x install.sh scripts/*.sh
./install.sh
sudo reboot
```

## Ya tienes JaKooLit — cambiar a ML4W

```bash
cd ~/fedora-setup
git pull
chmod +x scripts/*.sh
bash scripts/switch-to-ml4w.sh
```

Cierra sesión → entra en **Hyprland**.

## Atajos

| Atajo | Acción |
|-------|--------|
| `SUPER + Return` | Terminal |
| `SUPER + Q` / `SUPER + W` / `Alt + F4` | Cerrar ventana |
| `SUPER + T` | Flotar / mosaico |
| `SUPER + F` | Pantalla completa |
| `SUPER + Ctrl + Return` | Apps (Rofi) |
| `SUPER + E` | Archivos |
| `SUPER + B` | Firefox |
| `SUPER + Shift + C` | Cursor |
| `SUPER + Shift + B` | Mixlr — La Palabra del Señor |
| `SUPER + Shift + Y` | Biblia |
| `SUPER + Shift + P` | ~/Projects |

## Editar config

```bash
nano ~/.config/hypr/conf/binds.conf
nano ~/.config/hypr/conf/general.conf
hyprctl reload
```

Wallpaper: reemplaza `~/.config/ml4w/wallpapers/wallpaper.jpg` y reinicia `hyprpaper`.

## Referencias

- https://github.com/mylinuxforwork/hyprland-starter
- [docs/INSTALL.md](docs/INSTALL.md)
