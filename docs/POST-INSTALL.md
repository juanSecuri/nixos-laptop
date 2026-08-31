# Post-instalación

Ejecuta estos pasos **después del primer login** en Hyprland.

---

## 1. Wallpaper

Coloca una imagen en:

```bash
mkdir -p ~/Pictures
# Copia tu wallpaper favorito a:
# ~/Pictures/wallpaper.jpg
```

Luego reconstruye o reinicia hyprpaper:

```bash
rebuild
killall hyprpaper; hyprpaper &
```

---

## 2. Cursor IDE

```bash
mkdir -p ~/.local/share/cursor
curl -L https://downloader.cursor.sh/linux/appImage/x64 \
  -o ~/.local/share/cursor/cursor.AppImage
chmod +x ~/.local/share/cursor/cursor.AppImage
```

Abre Cursor desde Rofi (`Super + R`) o terminal: `cursor`.

---

## 3. Mixlr — La Palabra del Señor

Edita la URL del canal en `home/jloaiza10/faith.nix`:

```nix
mixlrUrl = "https://mixlr.com/TU-CANAL";
```

Luego:

```bash
rebuild
```

Atajo: **`Super + Shift + B`** o busca "La Palabra del Señor" en Rofi.

---

## 4. GitHub CLI

```bash
gh auth login
```

---

## 5. Docker (sin sudo)

```bash
newgrp docker
docker run hello-world
```

---

## 6. Clonar proyectos TPC

```bash
mkdir -p ~/Projects
cd ~/Projects

git clone git@github.com:juanSecuri/bookepping-cleanup-agent.git
git clone git@github.com:juanSecuri/cash-flow-system.git
git clone git@github.com:juanSecuri/dashboard-allapattah-CDC.git
git clone git@github.com:juanSecuri/contableIA-dianSiigo.git
git clone git@github.com:juanSecuri/iot-project.git
git clone git@github.com:juanSecuri/agente-ia-angela.git
```

---

## 7. Dev shells

```bash
cd ~/nixos-laptop
nix develop .#python
nix develop .#node
nix develop .#profit-catalyst
```

---

## Comandos diarios

```bash
rebuild    # aplicar cambios del flake
update     # actualizar inputs + rebuild
rollback   # revertir generación anterior
```
