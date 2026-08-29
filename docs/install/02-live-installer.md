# Step 2 — Install from live USB

**Time:** ~60–90 minutes · **Disk:** entire `/dev/nvme0n1` is erased

## 1. Boot from USB

1. Connect **Ethernet**
2. Insert USB
3. Power on → **F12** (boot menu) → select the USB / UEFI entry
4. Wait for the NixOS installer (terminal, may show a **QR code** and **root password**)

## 2. Open root terminal

You should already be **root** in the live environment. If not:

```bash
sudo -i
```

Note the **root password** on screen (for emergency SSH; the install script sets up localhost SSH automatically).

## 3. Clone the configuration

```bash
git clone https://github.com/juanSecuri/nixos-laptop.git /root/nixos-laptop
```

If you pushed SSH keys or other changes, they must be on `main` before cloning.

## 4. Preflight (optional but recommended)

```bash
bash /root/nixos-laptop/scripts/preflight-installer.sh
```

Fix any **ERROR** before continuing.

## 5. Run the installer

```bash
bash /root/nixos-laptop/scripts/install-from-usb.sh
```

- Type **`YES`** when prompted (confirms disk erase)
- Do **not** power off during build/install
- Expect long download/compile output (~45–90 min on first run)

### What the script does

1. Verifies you are on the **NixOS live** system (not Debian)
2. Configures **root SSH to localhost** (nixos-anywhere requirement)
3. **Dry-run** build of `#lenovo-v14`
4. Runs **nixos-anywhere** (no kexec — live installer detected)
5. **disko** partitions disk → **nixos-install** → **reboot**

## 6. First boot

After reboot, remove the USB when prompted (or select internal disk in boot menu).

You should see **SDDM** (login screen) → session **Hyprland**.

| Field | Value |
|-------|--------|
| User | `jloaiza10` |
| Password | Set during install, or the one configured in `default.nix` |

If you only see a tty, run `systemctl status display-manager` and check [TROUBLESHOOTING.md](./TROUBLESHOOTING.md).

## 7. Wi-Fi (after login)

Ethernet should work immediately. For Wi-Fi:

```bash
nmcli device wifi list
nmcli device wifi connect "YOUR_SSID" password "YOUR_PASSWORD"
```

## Next step

→ [03-post-install.md](./03-post-install.md)
