# Repository layout

```
nixos-laptop/
├── flake.nix                 # Entry point, nixosConfigurations + devShells
├── hosts/
│   └── lenovo-v14/
│       ├── default.nix       # Host module (imports all feature modules)
│       ├── disko.nix         # Disk layout (/dev/nvme0n1)
│       └── hardware-configuration.nix  # Generated at install (CPU, kernel modules)
├── modules/
│   ├── boot/                 # systemd-boot
│   ├── desktop/              # Hyprland, fonts, SDDM
│   ├── dev/                  # Python, Node, Java, Docker, DB, CLIs
│   ├── hardware/             # AMD laptop, audio, power
│   ├── networking/           # NetworkManager
│   └── security/             # agenix placeholders
├── home/
│   └── jloaiza10/            # Home Manager (Hyprland, shell, git, Cursor)
├── secrets/                  # agenix templates (no real secrets in git)
├── scripts/
│   ├── install-from-usb.sh   # Primary installer (live USB)
│   ├── preflight-installer.sh
│   └── install-from-debian.sh  # Deprecated (kexec)
└── docs/
    └── install/              # Step-by-step install guides
```

## Flake outputs

| Output | Description |
|--------|-------------|
| `nixosConfigurations.lenovo-v14` | Full system config |
| `devShells.x86_64-linux.default` | nixfmt |
| `devShells.x86_64-linux.python` | Python 3.11 + uv + OCR tools |
| `devShells.x86_64-linux.node` | Node 22 + pnpm |
| `devShells.x86_64-linux.profit-catalyst` | TPC monorepo shell |

## Change workflow

1. Edit files under `hosts/`, `modules/`, or `home/`
2. `sudo nixos-rebuild switch --flake ~/nixos-laptop#lenovo-v14`
3. Commit and push for backup
