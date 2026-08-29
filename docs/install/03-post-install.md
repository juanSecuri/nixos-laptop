# Step 3 — Post-install

Run these on **NixOS** after the first successful login (Hyprland / SDDM).

## Verify system

```bash
cat /etc/os-release | head -3
nixos-rebuild --version
```

## Sync configuration

```bash
cd ~/nixos-laptop
sudo nixos-rebuild switch --flake ~/nixos-laptop#lenovo-v14
```

Shell aliases (after opening a new Kitty terminal):

| Alias | Action |
|-------|--------|
| `rebuild` | Apply config changes |
| `update` | `nix flake update` + rebuild |
| `rollback` | Revert to previous generation |

## Docker

```bash
sudo usermod -aG docker jloaiza10
# Log out and back in (or reboot)
docker run hello-world
```

## Cursor IDE

```bash
mkdir -p ~/.local/share/cursor
curl -L "https://downloader.cursor.sh/linux/appImage/x64" \
  -o ~/.local/share/cursor/cursor.AppImage
chmod +x ~/.local/share/cursor/cursor.AppImage
```

Launch from Rofi (`Super + R`) → **Cursor**, or run `cursor` in terminal.

## GitHub CLI

```bash
gh auth login
```

## The Profit Catalyst — clone repos

```bash
mkdir -p ~/Projects/the-profit-catalyst
cd ~/Projects/the-profit-catalyst

gh repo clone juanSecuri/bookepping-cleanup-agent
gh repo clone juanSecuri/cash-flow-system
gh repo clone juanSecuri/dashboard-allapattah-CDC
gh repo clone juanSecuri/contableIA-dianSiigo
gh repo clone juanSecuri/iot-project
gh repo clone juanSecuri/agente-ia-angela
```

## Dev shells

```bash
cd ~/nixos-laptop
nix develop .#python           # Python / OCR
nix develop .#node               # Node / pnpm
nix develop .#profit-catalyst  # Full TPC stack
```

## Optional

- Wallpaper: save to `~/Pictures/wallpaper.jpg` and enable `hyprpaper` in `home/jloaiza10/hyprland.nix`
- Secrets: see `secrets/supabase.env.example` and `modules/security/secrets.nix`

## Daily Hyprland shortcuts

| Key | Action |
|-----|--------|
| `Super + Return` | Terminal (Kitty) |
| `Super + R` | Rofi launcher |
| `Super + E` | Thunar (files) |
| `Super + Q` | Close window |
| `Print` | Region screenshot |
