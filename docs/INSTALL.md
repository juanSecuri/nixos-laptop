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
3. Aplica tema ML4W oficial (waybar blanca, colores cyan/verde, wallpaper edificios) + keybinds de fe
4. Configura Cursor y Mixlr

## Personalización ML4W (después de Hyprland)

Si `personalize-ml4w.sh` se cerró antes de instalar dev tools, usa los comandos por separado (no necesitas `git pull`):

### A) Solo look visual (wallpaper, waybar, terminal)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/juanSecuri/nixos-laptop/main/scripts/ml4w-look.sh)
```

O con repo local:

```bash
bash ~/fedora-setup/scripts/ml4w-look.sh
```

### B) Solo herramientas dev (Docker, VS Code, Cursor, Mixlr)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/juanSecuri/nixos-laptop/main/scripts/install-tools.sh)
```

O por script:

```bash
bash ~/fedora-setup/scripts/install-tools.sh
```

### C) Todo junto (look + dev tools)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/juanSecuri/nixos-laptop/main/scripts/personalize-ml4w.sh)
```

O con repo local:

```bash
bash ~/fedora-setup/scripts/personalize-ml4w.sh
```

Packet Tracer: descarga `.deb` de NetAcad → `~/Downloads/` → vuelve a correr `install-tools.sh` o `dev-tools.sh`

## Sin pokemon / sin anime

- fastfetch sin logo
- zsh tema `robbyrussell` (no pokemon)
- wallpaper: ML4W por defecto (`assets/wallpapers/ml4w-default.jpg`)
- colores: tema oficial ML4W (bordes cyan/verde, waybar blanca)
