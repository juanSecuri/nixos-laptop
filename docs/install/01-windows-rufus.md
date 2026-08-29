# Step 1 — Create bootable USB (Windows + Rufus)

Do this on your **Windows** machine before the 7 PM install.

## 1. Download the NixOS installer ISO

Use the **nix-community** installer (SSH enabled, works with nixos-anywhere):

**Direct link:**

https://github.com/nix-community/nixos-images/releases/download/nixos-unstable/nixos-installer-x86_64-linux.iso

Save to e.g. `Downloads\nixos-installer-x86_64-linux.iso` (~800 MB).

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
