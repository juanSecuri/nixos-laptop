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
mkdir -p ~/Projects/the-profit-catalyst
cd ~/Projects/the-profit-catalyst

# Los 6 repos de The Profit Catalyst
gh repo clone juanSecuri/bookepping-cleanup-agent
gh repo clone juanSecuri/cash-flow-system
gh repo clone juanSecuri/dashboard-allapattah-CDC   # allapattah-finance
gh repo clone juanSecuri/contableIA-dianSiigo      # sistema-contable-dian-siigo
gh repo clone juanSecuri/iot-project
gh repo clone juanSecuri/agente-ia-angela           # fork de angelacatalyst

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

# Dev shells por proyecto
nix develop .#python
nix develop .#node
nix develop .#profit-catalyst   # shell unificado TPC
```

## The Profit Catalyst — tus 6 repos

| Repo | Qué hace | Stack |
|------|----------|-------|
| `bookepping-cleanup-agent` | Agente IA contable (OCR, Claude, estados financieros) | Python, FastAPI, Supabase, Docker, Render |
| `cash-flow-system` | Dashboard flujo de caja (TPC Flow) | Python + JS, SQLite, Render, Makefile |
| `dashboard-allapattah-CDC` | Dashboard finanzas Allapattah + QuickBooks | Python, Panel, QBO, Render |
| `contableIA-dianSiigo` | Contabilidad DIAN + SIIGO + OCR facturas | Python, FastAPI, Azure, Selenium, Docker |
| `iot-project` | IoT alertas + backend FastAPI | Python, FastAPI, embebido |
| `agente-ia-angela` | Agente finanzas Angela + QuickBooks OAuth | Python, FastAPI, PostgreSQL, Docker |

Tu NixOS ya trae: Python 3.11, uv, Docker, Supabase CLI, Azure CLI, tesseract (OCR), chromedriver (Selenium), PostgreSQL client, Node/pnpm, gh.

## Guía paso a paso (explicación simple)

### ¿Qué estamos haciendo?

Imagina que tu laptop es una casa. Hoy vives en **Debian** (una casa genérica). Quieres mudarte a **NixOS** (una casa donde **cada cosa está escrita en un plano** — si se daña algo, reconstruyes la casa entera desde el plano en 1 comando).

**Sin USB:** no necesitas llave USB. Desde Debian, un programa (`nixos-anywhere`) reinicia tu laptop en modo instalador (por RAM), borra el disco, e instala NixOS con tu config de GitHub.

---

### ANTES de tocar nada (Fase 0)

**Paso 1 — Guarda tus cosas**
Copia `/home/jloaiza10` a Google Drive, disco externo, etc. La instalación **borra todo**.

**Paso 2 — Conecta el cable de internet (Ethernet)**
El instalador no configura Wi-Fi. Cable al router.

**Paso 3 — Abre terminal y pega esto, uno por uno:**

```bash
# ¿Tu laptop puede hacer el truco de reinicio en RAM?
grep CONFIG_KEXEC=y /boot/config-$(uname -r)

# Instala SSH (para que el instalador se hable solo contigo)
sudo apt install openssh-server
sudo systemctl enable --now ssh
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
ssh localhost    # si entra sin pedir password, OK

# Instala Nix (el constructor de NixOS)
sh <(curl -L https://nixos.org/nix/install) --daemon
. /etc/profile.d/nix.sh
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Descarga TU plano de la casa
git clone https://github.com/juanSecuri/nixos-laptop.git ~/nixos-laptop
```

**Paso 4 — Pon tu llave SSH en el plano**

Edita `~/nixos-laptop/hosts/lenovo-v14/default.nix` y dentro de `openssh.authorizedKeys.keys` pega el contenido de:

```bash
cat ~/.ssh/id_ed25519.pub
```

---

### LA INSTALACIÓN (Fase 2) — esto borra Debian

```bash
cd ~/nixos-laptop
bash scripts/install-from-debian.sh
```

Te pedirá escribir `YES`. Luego pasa solo:

1. **kexec** — reinicia en instalador NixOS (en RAM, no en disco aún)
2. **disko** — parte el disco: boot 512M, swap 16G, resto btrfs
3. **install** — instala NixOS + Hyprland + Python + Docker + todo
4. **reboot** — reinicia y ya eres NixOS

Inicias sesión como `jloaiza10`. Verás **Hyprland** (escritorio oscuro minimalista).

---

### DESPUÉS del reboot (Fase 3)

**Paso 1 — Entra a Docker**

```bash
sudo usermod -aG docker jloaiza10
# cierra sesión y vuelve a entrar
```

**Paso 2 — Instala Cursor**

```bash
mkdir -p ~/.local/share/cursor
curl -L "https://downloader.cursor.sh/linux/appImage/x64" -o ~/.local/share/cursor/cursor.AppImage
chmod +x ~/.local/share/cursor/cursor.AppImage
```

**Paso 3 — Clona los 6 repos TPC**

```bash
mkdir -p ~/Projects/the-profit-catalyst && cd ~/Projects/the-profit-catalyst
gh auth login
gh repo clone juanSecuri/bookepping-cleanup-agent
gh repo clone juanSecuri/cash-flow-system
gh repo clone juanSecuri/dashboard-allapattah-CDC
gh repo clone juanSecuri/contableIA-dianSiigo
gh repo clone juanSecuri/iot-project
gh repo clone juanSecuri/agente-ia-angela
```

**Paso 4 — Prueba un proyecto (ejemplo bookkeeping)**

```bash
cd ~/nixos-laptop && nix develop .#profit-catalyst
cd ~/Projects/the-profit-catalyst/bookepping-cleanup-agent
cp .env.example .env   # edita con tus keys de Supabase
uv sync                # o pip install -r requirements
docker compose up -d   # si usa Docker
```

Repite la idea para cada repo: copiar `.env.example` → `.env`, instalar deps, `docker compose up` o `make run`.

---

### Cada repo — qué comando usar

| Repo | Cómo arrancarlo (típico) |
|------|--------------------------|
| `bookepping-cleanup-agent` | `uv sync` → `docker compose up` o `uvicorn` |
| `cash-flow-system` | `make run` o `./run.sh` |
| `dashboard-allapattah-CDC` | `pip install -r requirements` → ver `render.yaml` |
| `contableIA-dianSiigo` | `docker compose up` (Azure/Selenium en .env) |
| `iot-project` | `cd backend && uvicorn ...` |
| `agente-ia-angela` | `docker compose up` (PostgreSQL + FastAPI) |

---

### Tu vida diaria en NixOS (Fase 4)

| Quieres... | Comando |
|------------|---------|
| Cambiaste algo en la config | `rebuild` (alias en zsh) |
| Algo se rompió | `rollback` |
| Actualizar paquetes | `update` |
| Abrir terminal | `Super + Enter` |
| Abrir apps | `Super + R` |
| Abrir Cursor | Rofi → Cursor |

**Regla de oro:** casi todo tu sistema vive en `~/nixos-laptop`. Lo editas, corres `rebuild`, y listo.

---

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
