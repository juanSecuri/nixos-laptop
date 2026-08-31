# NixOS Laptop — Guía de instalación

Instalación completa para **Lenovo V14 G4 ABP** con Hyprland, stack de desarrollo y acceso a Mixlr / Biblia.

---

## Antes de empezar

1. **Backup** de `/home/jloaiza10` — se borra todo el disco.
2. **Secure Boot → Disabled** en BIOS (F2).
3. **Ethernet** conectado durante la instalación.
4. USB ≥ 8 GB.

---

## Paso 1 — Crear USB en Windows

1. Descarga la **Minimal ISO** (recomendada, una sola opción de arranque):
   - https://nixos.org/download.html
   - O directo: https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso

2. Abre **Rufus**:
   - Dispositivo → tu USB
   - ISO → el archivo descargado
   - GPT + UEFI
   - START → DD Image mode si pregunta

> La **Graphical ISO** muestra 4 entradas (GNOME/Plasma) — es normal, solo elige cualquiera. La Minimal evita esa confusión.

---

## Paso 2 — BIOS y arranque

1. Apaga la laptop, mete la USB, conecta Ethernet.
2. Enciende → **F12** → elige el USB.
3. En Minimal ISO: login `root` (sin contraseña, o `passwd root` si pide).

---

## Paso 3 — Instalar (un comando)

```bash
passwd root
systemctl start sshd

git clone https://github.com/juanSecuri/nixos-laptop.git /root/nixos-laptop
bash /root/nixos-laptop/scripts/install.sh
```

Escribe **`YES`** cuando lo pida.

**Espera 45–90 minutos.** No apagues. Ethernet conectado.

---

## Paso 4 — Primer arranque

1. Saca el USB y reinicia.
2. Login en **SDDM** → usuario `jloaiza10`.
3. Sesión **Hyprland**.

```bash
cat /etc/os-release   # debe decir NixOS
```

---

## Qué se instala

| Área | Contenido |
|------|-----------|
| **Escritorio** | Hyprland, SDDM Catppuccin, Waybar, Rofi, Kitty |
| **Desarrollo** | Python 3.11, Node 22, Java 21, Docker, Supabase CLI, Azure CLI |
| **Fe / audio** | Mixlr (La Palabra del Señor), Biblia YouVersion, Firefox, mpv |
| **Disco** | ESP 512M + swap 16G + btrfs (`/`, `/home`, `/nix`, `/var/log`) |

---

## Atajos Hyprland

| Atajo | Acción |
|-------|--------|
| `Super + Return` | Terminal |
| `Super + R` | Lanzador de apps |
| `Super + E` | Archivos |
| `Super + Shift + B` | La Palabra del Señor (Mixlr) |
| `Super + Print` | Captura de pantalla |

---

## Problemas

Ver [TROUBLESHOOTING.md](./TROUBLESHOOTING.md).
