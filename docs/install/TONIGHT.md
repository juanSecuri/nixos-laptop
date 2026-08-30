# Tonight — quick reference (~7 PM)

Use the **official ISO** from https://nixos.org/download.html

**Full baby-step guide:** [GUIA-OFICIAL-ES.md](./GUIA-OFICIAL-ES.md)

## On Windows

1. Download **Minimal ISO** from nixos.org → save to **Downloads** (not USB)
2. **Rufus** → GPT + UEFI → DD mode → START
3. Backup `/home/jloaiza10`

## On laptop

1. BIOS: **Secure Boot OFF** (F2)
2. **Ethernet** + USB → **F12**
3. Login: **root** (official ISO)

```bash
passwd root
systemctl start sshd
git clone https://github.com/juanSecuri/nixos-laptop.git /root/nixos-laptop
chmod +x /root/nixos-laptop/scripts/*.sh
bash /root/nixos-laptop/scripts/install-from-usb.sh
```

4. Type **YES** → wait 45–90 min → login `jloaiza10`
