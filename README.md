# NixOS Dev Laptop — Lenovo V14 G4 ABP

Configuración declarativa de NixOS para la laptop de **jloaiza10** (AMD Ryzen 7 7730U, 22 GB RAM).

- **WM:** Hyprland + Waybar + Rofi (Catppuccin Mocha)
- **Stack dev:** Python 3.11, Node 22/pnpm, Java 21/Maven, Docker, Supabase CLI, Azure CLI, gh, Vercel
- **Instalación:** nixos-anywhere desde Debian (sin USB)

## Estructura

```
flake.nix
hosts/lenovo-v14/     # Host + disko + hardware (generado en install)
modules/              # Módulos reutilizables (hardware, dev, desktop)
home/jloaiza10/       # Home Manager (Hyprland, shell, git, Cursor)
secrets/              # Plantillas agenix (no commitear .age con secretos)
```

## Requisitos previos (en Debian Trixie)

1. **Backup** de `/home/jloaiza10`
2. **Cable Ethernet** conectado
3. Verificar kexec: `grep CONFIG_KEXEC=y /boot/config-$(uname -r)`

### SSH local

```bash
sudo apt install openssh-server
sudo systemctl enable --now ssh
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
ssh localhost   # debe entrar sin password
```

### Instalar Nix + flakes

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
. /etc/profile.d/nix.sh
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### Clonar este repo

```bash
git clone https://github.com/juanSecuri/nixos-laptop.git ~/nixos-laptop
cd ~/nixos-laptop
```

### Antes de instalar

1. Añade tu clave SSH pública en `hosts/lenovo-v14/default.nix` → `users.users.jloaiza10.openssh.authorizedKeys.keys`
2. Si tu disco no es `/dev/nvme0n1`, edita `hosts/lenovo-v14/disko.nix`

## Instalación con nixos-anywhere

**Esto borra todo el disco.**

```bash
cd ~/nixos-laptop

nix run github:nix-community/nixos-anywhere -- \
  --flake .#lenovo-v14 \
  --generate-hardware-config nixos-generate-config ./hosts/lenovo-v14/hardware-configuration.nix \
  --target-host jloaiza10@localhost \
  --build-on local
```

Fases: `kexec` → `disko` (particiones) → `install` → `reboot`.

Tras el reboot, inicia sesión como `jloaiza10` en Hyprland (SDDM).

## Post-instalación

```bash
# Aplicar cambios de config
sudo nixos-rebuild switch --flake ~/nixos-laptop#lenovo-v14

# Proyectos
mkdir -p ~/Projects
cd ~/Projects && gh repo clone juanSecuri/en-manos-del-alfarero

# Cursor AppImage
mkdir -p ~/.local/share/cursor
curl -L "https://downloader.cursor.sh/linux/appImage/x64" -o ~/.local/share/cursor/cursor.AppImage
chmod +x ~/.local/share/cursor/cursor.AppImage

# Wallpaper opcional
curl -L "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=1920" -o ~/Pictures/wallpaper.jpg
# Luego habilita hyprpaper en home/jloaiza10/hyprland.nix si lo deseas

# Docker (grupo docker — re-login)
sudo usermod -aG docker jloaiza10

# Verificar stack
python3 --version    # 3.11
node --version       # 22
pnpm --version
java --version       # 21
docker compose version
supabase --version
gh auth login
```

## Uso diario

```bash
# Alias en zsh (ya configurados)
rebuild    # sudo nixos-rebuild switch --flake ~/nixos-laptop#lenovo-v14
update     # nix flake update + rebuild
rollback   # revertir generación anterior

# Dev shells por proyecto
nix develop .#python
nix develop .#node
```

## Atajos Hyprland

| Atajo | Acción |
|-------|--------|
| `Super + Return` | Terminal (Kitty) |
| `Super + R` / `Super + Space` | Rofi launcher |
| `Super + Q` | Cerrar ventana |
| `Super + E` | Thunar (archivos) |
| `Super + 1-9` | Workspace |
| `Super + Shift + 1-9` | Mover ventana a workspace |
| `Print` | Screenshot región |
| `Super + Print` | Screenshot a ~/Pictures |

## Layout de disco

| Partición | Tamaño | FS | Montaje |
|-----------|--------|-----|---------|
| ESP | 512M | vfat | `/boot` |
| swap | 16G | swap | — |
| root | resto | btrfs | `/`, `/home`, `/nix`, `/var/log` (subvols) |

## Secretos (agenix)

```bash
sudo mkdir -p /etc/agenix
sudo age-keygen -o /etc/agenix/keys.txt
sudo cp /etc/agenix/keys.txt.pub secrets/
# Editar modules/security/secrets.nix y descomentar age.secrets
agenix -e secrets/supabase.env.age
sudo nixos-rebuild switch --flake ~/nixos-laptop#lenovo-v14
```

## Troubleshooting

| Problema | Solución |
|----------|----------|
| Wi-Fi no funciona | Conectar Ethernet; `boot.kernelPackages = pkgs.linuxPackages_latest` ya está en amd-laptop.nix |
| kexec falla | `sudo modprobe kexec`; verificar `CONFIG_KEXEC=y` |
| nixos-anywhere pide sudo | Usar `--target-host jloaiza10@localhost` con NOPASSWD wheel o root |
| Cursor no abre | Descargar AppImage; ejecutar con `--no-sandbox` |
| Rollback | `sudo nixos-rebuild switch --rollback` |

## Licencia

Uso personal — fork libremente.
