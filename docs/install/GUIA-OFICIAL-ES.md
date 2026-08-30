# Guía completa — ISO oficial NixOS (paso a paso)

Instala NixOS en tu **Lenovo V14** con la ISO **oficial** de [nixos.org](https://nixos.org/download.html) y tu config de GitHub.

> **No uses kexec desde Debian** — en tu laptop da pantalla negra.  
> **No uses la ISO de GitHub nix-community** si prefieres la oficial — ambas funcionan; esta guía es para la **oficial**.

---

## Parte 1 — En Windows (antes de tocar la laptop)

### Paso 1: Backup
Copia `/home/jloaiza10` a Google Drive o disco externo. **Se borra todo.**

### Paso 2: Descargar ISO oficial

Abre en el navegador:

**https://nixos.org/download.html**

Descarga:

- **Graphical ISO** — si quieres ver escritorio en el instalador (más fácil)
- **Minimal ISO** — más liviana (recomendada si tienes poca RAM en live)

O enlace directo (unstable minimal):

**https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso**

Guarda en `C:\Users\juane\Downloads\` (no en la USB).

### Paso 3: Rufus

1. USB ≥ 4 GB
2. Abre **Rufus**
3. Dispositivo → tu USB
4. Seleccionar → el `.iso` desde **Downloads**
5. GPT + UEFI
6. START → **DD Image mode** si pregunta
7. Espera READY → CLOSE

---

## Parte 2 — BIOS (una vez)

1. Apaga la laptop
2. **F2** → BIOS
3. **Secure Boot → Disabled**
4. **F10** → guardar y salir

---

## Parte 3 — Arrancar USB

1. **Ethernet** al router
2. USB metida
3. Encender → **F12** → elegir USB
4. En el menú de NixOS elige **NixOS installer**

### Login (ISO oficial minimal)

- Usuario: **`root`**
- Sin password (Enter)
- Si pide password, escribe una y recuérdala

Abre terminal (o ya estás en tty).

---

## Parte 4 — Instalar (copiar y pegar)

### A) Red y SSH (solo ISO oficial minimal)

```bash
passwd root
systemctl start sshd
```

### B) Clonar tu config

```bash
git clone https://github.com/juanSecuri/nixos-laptop.git /root/nixos-laptop
cd /root/nixos-laptop
git pull
chmod +x scripts/*.sh
```

### C) Instalar (un solo comando)

```bash
bash /root/nixos-laptop/scripts/install-from-usb.sh
```

Cuando pregunte → escribe **`YES`** (mayúsculas).

### Qué hace el script

1. Monta tu disco Debian (`nvme0n1p2`) para **espacio** (no usa solo RAM)
2. Activa swap (`nvme0n1p3`)
3. Compila **poco** — descarga binarios de cache.nixos.org
4. Borra disco e instala NixOS + Hyprland + dev tools
5. Reinicia

**Espera 45–90 min. No apagues. Ethernet conectado.**

---

## Parte 5 — Primer arranque

1. Saca la USB
2. Login **SDDM**: usuario `jloaiza10`
3. Sesión **Hyprland**

```bash
cat /etc/os-release
```

Debe decir **NixOS**.

---

## Parte 6 — Después (opcional)

Ver [03-post-install.md](./03-post-install.md): Docker, Cursor, repos TPC.

---

## Si falla otra vez

| Error | Qué hacer |
|-------|-----------|
| No space left on device | Asegúrate `nvme0n1p2` es ext4 con espacio; `git pull` y reintenta script |
| OOM / killed | `free -h` debe mostrar swap; script lo activa solo |
| SSH failed | `passwd root` + `systemctl start sshd` |
| Build Hyprland | `git pull` — ya usa binarios, no compila |

---

## Tus particiones (Lenovo V14)

| Partición | Uso ahora |
|-----------|-----------|
| `nvme0n1p1` | EFI 512M (no tocar para swap) |
| `nvme0n1p2` | Debian ext4 → espacio temporal install |
| `nvme0n1p3` | Swap Debian → se activa en install |

Después del install, disko crea layout nuevo (ESP + swap 16G + btrfs).
