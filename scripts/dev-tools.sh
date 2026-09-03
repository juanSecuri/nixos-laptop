#!/usr/bin/env bash
set -euo pipefail

echo "=== Herramientas de desarrollo ==="

# Repos oficiales
sudo dnf install -y \
  git gh git-lfs \
  docker docker-compose \
  python3 python3-pip python3-virtualenv \
  nodejs npm \
  java-21-openjdk java-21-openjdk-devel maven \
  gcc gcc-c++ make cmake pkg-config \
  wireshark \
  libreoffice \
  firefox \
  vim nano \
  jq ripgrep fd-find bat eza fzf tmux htop \
  tesseract poppler-utils \
  2>/dev/null || true

# VS Code (Microsoft repo)
if ! command -v code >/dev/null 2>&1; then
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'cat > /etc/yum.repos.d/vscode.repo << EOF
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF'
  sudo dnf install -y code
fi

# Docker group
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER" 2>/dev/null || true

# Azure CLI
if ! command -v az >/dev/null 2>&1; then
  sudo dnf install -y azure-cli 2>/dev/null || \
    echo "Azure CLI: sudo dnf install azure-cli (o ver docs.microsoft.com)"
fi

# Supabase CLI via npm
if command -v npm >/dev/null 2>&1; then
  sudo npm install -g supabase 2>/dev/null || npm install -g supabase 2>/dev/null || true
fi

# uv (Python)
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# pnpm
if command -v corepack >/dev/null 2>&1; then
  sudo corepack enable
  corepack prepare pnpm@latest --activate 2>/dev/null || true
fi

# Cisco Packet Tracer — requiere .deb descargado de NetAcad
PACKET_TRACER_DEB="$HOME/Downloads/PacketTracer*.deb"
if compgen -G "$PACKET_TRACER_DEB" >/dev/null; then
  DEB_FILE=$(ls -1 $HOME/Downloads/PacketTracer*.deb | head -1)
  echo "Instalando Packet Tracer desde $DEB_FILE"
  sudo dnf install -y alien libicu 2>/dev/null || true
  sudo alien -r "$DEB_FILE"
  sudo rpm -i packettracer*.rpm 2>/dev/null || echo "Packet Tracer: revisa dependencias manualmente"
else
  echo "Packet Tracer: descarga el .deb desde NetAcad a ~/Downloads/ y vuelve a correr este script"
fi

# Aliases útiles
mkdir -p "$HOME/.local/bin"
cat > "$HOME/.local/bin/projects" << 'EOF'
#!/bin/bash
cd ~/Projects 2>/dev/null || mkdir -p ~/Projects && cd ~/Projects
EOF
chmod +x "$HOME/.local/bin/projects"

echo "Dev tools instalados. Cierra sesión para grupo docker."
