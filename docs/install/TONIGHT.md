# Tonight — quick reference (~7 PM)

**Recommended if live USB + GitHub fails:** [INSTALACION-SIMPLE-ES.md](./INSTALACION-SIMPLE-ES.md) (2 phases, no GitHub on USB)

Use the **official ISO** from https://nixos.org/download.html

**Full baby-step guide:** [GUIA-OFICIAL-ES.md](./GUIA-OFICIAL-ES.md)

## Simple install (phase 1 — no GitHub)

```bash
sudo -i
export PATH=/run/current-system/sw/bin:$PATH
curl -fsSL https://raw.githubusercontent.com/juanSecuri/nixos-laptop/main/scripts/install-minimal-usb.sh -o /tmp/install-minimal-usb.sh
chmod +x /tmp/install-minimal-usb.sh
bash /tmp/install-minimal-usb.sh
```

→ **YES** → `reboot` → login `jloaiza10` / `nixos123`  
→ Phase 2: [FASE-2-FLAKE-ES.md](./FASE-2-FLAKE-ES.md)
