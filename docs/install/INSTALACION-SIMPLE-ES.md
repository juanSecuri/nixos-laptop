# Instalación simple — 2 fases (recomendada)

Si el USB live + GitHub + `nixos-anywhere` te da muchos errores, usa este camino.

| Fase | Dónde | Qué | GitHub |
|------|-------|-----|--------|
| **1** | USB live | NixOS mínimo (terminal, red, usuario) | **No** |
| **2** | Ya instalado | Hyprland + dev stack + flake | **Sí** |

---

## Fase 1 — USB (sin GitHub)

### 1. Windows

ISO oficial: https://nixos.org/download.html → **Minimal**  
Rufus → GPT + UEFI → DD mode

### 2. Laptop

- Secure Boot **OFF** (F2)
- Ethernet + USB → **F12**

### 3. Terminal

```bash
sudo -i
export PATH=/run/current-system/sw/bin:$PATH
```

Si no tienes el repo en USB, copia el script a mano o usa `curl` después de montar red:

```bash
curl -fsSL https://raw.githubusercontent.com/juanSecuri/nixos-laptop/main/scripts/install-minimal-usb.sh -o /tmp/install-minimal-usb.sh
chmod +x /tmp/install-minimal-usb.sh
bash /tmp/install-minimal-usb.sh
```

**O** si ya clonaste antes:

```bash
bash /root/nixos-laptop/scripts/install-minimal-usb.sh
```

Escribe **`YES`** cuando pida confirmación.

Al final:

```bash
reboot
```

Saca el USB.

### 4. Primer login

- Usuario: `jloaiza10`
- Password: `nixos123`

---

## Fase 2 — Config completa

Ver **[FASE-2-FLAKE-ES.md](./FASE-2-FLAKE-ES.md)**

Resumen:

```bash
git clone https://github.com/juanSecuri/nixos-laptop.git ~/nixos-laptop
cd ~/nixos-laptop
sudo nixos-rebuild switch --flake .#lenovo-v14
sudo reboot
```

---

## ¿Por qué funciona mejor?

- El USB live tiene poca RAM y `/etc` de solo lectura
- Fase 1 solo usa herramientas **de la ISO**
- Fase 2 compila/descarga en tu **disco grande**, con el daemon normal
