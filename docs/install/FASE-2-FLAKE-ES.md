# Fase 2 — Tu config completa (después de instalar lo mínimo)

Ya tienes NixOS funcionando. Ahora aplicas Hyprland, dev stack, etc. desde GitHub.

**Ventaja:** esto corre en el disco real, con espacio de sobra. No depende del USB live.

---

## Paso 1 — Login

Usuario: `jloaiza10`  
Password temporal: `nixos123` (cámbiala después con `passwd`)

Ethernet conectado.

---

## Paso 2 — Clonar repo

```bash
git clone https://github.com/juanSecuri/nixos-laptop.git ~/nixos-laptop
cd ~/nixos-laptop
```

Si `git clone` falla, usa:

```bash
curl -fsSL https://github.com/juanSecuri/nixos-laptop/archive/refs/heads/main.tar.gz -o /tmp/repo.tar.gz
mkdir -p ~/nixos-laptop
tar -xzf /tmp/repo.tar.gz -C ~/nixos-laptop --strip-components=1
cd ~/nixos-laptop
```

---

## Paso 3 — Aplicar config completa

```bash
sudo nixos-rebuild switch --flake .#lenovo-v14
```

**Aviso:** esto reformatea el disco con **btrfs** (disko). Tus datos de Debian ya no están — solo lo que hay en NixOS mínimo.

Tarda **1–2 horas** la primera vez. No apagues.

---

## Paso 4 — Reiniciar

```bash
sudo reboot
```

Login: `jloaiza10` → escritorio **Hyprland**.

---

## Paso 5 — Post-instalación

Ver [03-post-install.md](./03-post-install.md): Docker, Cursor, repos TPC, `gh auth login`.

---

## Si algo falla en fase 2

Puedes seguir usando el sistema mínimo (GNOME no, pero terminal + SSH + red funcionan).

Pega el error en el chat y lo arreglamos sin reinstalar desde USB.
