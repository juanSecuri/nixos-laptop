# Instalación — ML4W Hyprland

## Instalación nueva

```bash
git clone https://github.com/juanSecuri/nixos-laptop.git ~/fedora-setup
cd ~/fedora-setup
chmod +x install.sh scripts/*.sh
./install.sh
sudo reboot
```

Login → sesión **Hyprland**.

## Migrar desde JaKooLit (tu caso)

```bash
cd ~/fedora-setup
git pull
bash scripts/switch-to-ml4w.sh
```

Esto:
1. Borra config JaKooLit (pokemon, quickshell, errores rojos)
2. Instala [ML4W hyprland-starter](https://github.com/mylinuxforwork/hyprland-starter)
3. Aplica wallpaper del león + keybinds de fe
4. Configura Cursor y Mixlr

## Pendiente después

```bash
bash ~/fedora-setup/scripts/cursor.sh      # Cursor IDE
bash ~/fedora-setup/scripts/dev-tools.sh   # Docker, Packet Tracer, etc.
```

Packet Tracer: descarga `.deb` de NetAcad → `~/Downloads/` → `dev-tools.sh`

## Sin pokemon / sin anime

- fastfetch sin logo
- zsh tema `robbyrussell` (no pokemon)
- wallpaper: león (`assets/wallpapers/wallpaper.jpg`)
- colores sobrios gris/azul
