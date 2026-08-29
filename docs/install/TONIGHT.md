# Tonight — quick reference (~7 PM)

## On Windows (before laptop)

1. Download ISO:  
   https://github.com/nix-community/nixos-images/releases/download/nixos-unstable/nixos-installer-x86_64-linux.iso
2. **Rufus** → GPT + UEFI → write USB (DD mode if asked)
3. Backup `/home/jloaiza10`

## On laptop

1. BIOS: **Secure Boot OFF** (F2)
2. **Ethernet** plugged in
3. **F12** → boot USB
4. Root terminal:

```bash
git clone https://github.com/juanSecuri/nixos-laptop.git /root/nixos-laptop
chmod +x /root/nixos-laptop/scripts/*.sh
bash /root/nixos-laptop/scripts/install-from-usb.sh
```

5. Type **YES** → wait **45–90 min** → reboot
6. Login: `jloaiza10` at **SDDM** → Hyprland

Full docs: [docs/install/README.md](./README.md)
