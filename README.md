# nixos-laptop

Declarative NixOS configuration for **jloaiza10** — Lenovo V14 G4 ABP (AMD Ryzen 7 7730U, 22 GB RAM).

| | |
|---|---|
| **Desktop** | Hyprland · Waybar · Rofi · Catppuccin Mocha |
| **Dev stack** | Python 3.11 · Node 22 · Java 21 · Docker · Supabase · Azure · gh |
| **Install method** | **USB + Rufus** (official or minimal ISO) → live installer → `install-from-usb.sh` |
| **Flake host** | `#lenovo-v14` |

## Install tonight (~7 PM)

**Full guide (Spanish):** [docs/install/GUIA-OFICIAL-ES.md](docs/install/GUIA-OFICIAL-ES.md)

1. **[Checklist](docs/install/00-checklist.md)** — backup, BIOS, Ethernet  
2. **[Windows + Rufus](docs/install/01-windows-rufus.md)** — official ISO from nixos.org  
3. **[Live installer](docs/install/02-live-installer.md)** — boot USB and run install  
4. **[Post-install](docs/install/03-post-install.md)** — Docker, Cursor, TPC repos  

**One-liner on the live USB (root terminal):**

```bash
git clone https://github.com/juanSecuri/nixos-laptop.git /root/nixos-laptop
bash /root/nixos-laptop/scripts/install-from-usb.sh
```

> kexec from Debian **does not work** on this laptop (black screen). Use USB only.  
> See [Troubleshooting](docs/install/TROUBLESHOOTING.md).

## Repository structure

```
flake.nix
hosts/lenovo-v14/     # Host, disko, hardware-config (generated at install)
modules/              # System modules (hardware, desktop, dev, …)
home/jloaiza10/       # Home Manager profile
scripts/              # install-from-usb.sh, preflight-installer.sh
docs/                 # Install guides and architecture notes
```

Details: [docs/architecture.md](docs/architecture.md) · Hardware: [docs/hardware/lenovo-v14.md](docs/hardware/lenovo-v14.md)

## Before install

1. **Backup** `/home/jloaiza10` — install wipes `/dev/nvme0n1`
2. **Secure Boot → Disabled** in BIOS
3. **Ethernet** connected during install
4. Optional: add your SSH public key in `hosts/lenovo-v14/default.nix`:

```nix
openssh.authorizedKeys.keys = [
  "ssh-ed25519 AAAA... jloaiza10@lenovo-v14"
];
```

## Daily use (after install)

```bash
rebuild    # sudo nixos-rebuild switch --flake ~/nixos-laptop#lenovo-v14
update     # nix flake update && rebuild
rollback   # revert last generation
```

| Shortcut | Action |
|----------|--------|
| `Super + Return` | Terminal |
| `Super + R` | App launcher |
| `Super + E` | File manager |

## Dev shells

```bash
nix develop .#python
nix develop .#node
nix develop .#profit-catalyst   # The Profit Catalyst monorepo
```

## The Profit Catalyst repos

| Repo | Stack |
|------|--------|
| `bookepping-cleanup-agent` | Python, FastAPI, Supabase, OCR |
| `cash-flow-system` | Python, SQLite |
| `dashboard-allapattah-CDC` | Python, Panel, QuickBooks |
| `contableIA-dianSiigo` | Python, DIAN/SIIGO, Selenium |
| `iot-project` | FastAPI, embedded |
| `agente-ia-angela` | FastAPI, PostgreSQL, Docker |

## Disk layout

| Partition | Size | Mount |
|-----------|------|-------|
| ESP | 512 MiB | `/boot` |
| swap | 16 GiB | — |
| btrfs | remainder | `/`, `/home`, `/nix`, `/var/log` |

Defined in `hosts/lenovo-v14/disko.nix`.

## License

Personal use — fork freely.
