# Step 1 — Create bootable USB (Windows + Rufus)

Do this on your **Windows** machine before the 7 PM install.

## 1. Download the NixOS installer ISO

### Option A — Official (recommended)

Download from **[nixos.org/download](https://nixos.org/download.html)**:

- **Minimal ISO** (lighter):  
  https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso
- **Graphical ISO** (desktop in installer):  
  https://channels.nixos.org/nixos-unstable/latest-nixos-graphical-x86_64-linux.iso

Full Spanish walkthrough: [GUIA-OFICIAL-ES.md](./GUIA-OFICIAL-ES.md)

### Option B — nix-community (SSH + QR on screen)

https://github.com/nix-community/nixos-images/releases/download/nixos-unstable/nixos-installer-x86_64-linux.iso

Save to e.g. `C:\Users\juane\Downloads\` — **not on the USB stick**.

## 2. Insert USB

- Minimum **4 GB**
- **Back up** anything on the stick — it will be erased

## 3. Rufus settings

| Setting | Value |
|---------|--------|
| Device | Your USB drive |
| Boot selection | **Disk or ISO image** → select the `.iso` |
| Partition scheme | **GPT** |
| Target system | **UEFI (non CSM)** |
| File system | FAT32 (default) |
| Cluster size | Default |

Click **START**.

- If Rufus asks **ISOHybrid vs DD mode** → choose **DD Image mode** (recommended for NixOS).
- Wait until **READY** appears.

## 4. Safely eject USB

Remove the stick from Windows. You will boot the laptop from it.

## 5. BIOS reminder

On the Lenovo, before booting USB:

1. Power off
2. **F2** → UEFI setup
3. **Secure Boot → Disabled**
4. Save & exit

## Next step

→ [02-live-installer.md](./02-live-installer.md)
