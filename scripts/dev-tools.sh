#!/usr/bin/env bash
# Herramientas de desarrollo para Fedora — pasos opcionales, no aborta en fallos.
set -uo pipefail

log()  { echo "[$(date +%H:%M:%S)] $*"; }
warn() { log "⚠ $*"; }

echo "=== Herramientas de desarrollo ==="

# Paquetes base (Fedora repos)
log "Instalando paquetes dnf..."
sudo dnf install -y \
  git gh git-lfs \
  python3 python3-pip python3-virtualenv \
  nodejs npm \
  java-21-openjdk java-21-openjdk-devel maven \
  gcc gcc-c++ make cmake pkg-config \
  wireshark \
  libreoffice \
  firefox \
  vim nano \
  jq ripgrep fd-find bat fzf tmux htop \
  tesseract poppler-utils \
  2>/dev/null || warn "algunos paquetes dnf no se instalaron"

# eza: nombre en Fedora puede variar
if ! command -v eza >/dev/null 2>&1; then
  sudo dnf install -y eza 2>/dev/null || \
    sudo dnf install -y eza-cli 2>/dev/null || \
    warn "eza no disponible en repos — opcional"
fi

# Docker en Fedora = moby-engine (no existe paquete 'docker')
log "Docker (moby-engine)..."
if ! command -v docker >/dev/null 2>&1; then
  sudo dnf install -y moby-engine docker-compose moby-cli 2>/dev/null || \
    warn "moby-engine no instalado — prueba: sudo dnf install moby-engine docker-compose"
fi
if command -v docker >/dev/null 2>&1 || systemctl list-unit-files docker.service &>/dev/null; then
  sudo systemctl enable --now docker 2>/dev/null || true
  sudo usermod -aG docker "$USER" 2>/dev/null || true
else
  warn "Docker daemon no disponible — revisa: sudo dnf install moby-engine"
fi

# VS Code (Microsoft repo)
if ! command -v code >/dev/null 2>&1; then
  log "VS Code..."
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc 2>/dev/null || true
  if [[ ! -f /etc/yum.repos.d/vscode.repo ]]; then
    sudo tee /etc/yum.repos.d/vscode.repo >/dev/null << 'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
  fi
  sudo dnf install -y code 2>/dev/null || warn "VS Code no instalado"
fi

# Azure CLI (opcional)
if ! command -v az >/dev/null 2>&1; then
  sudo dnf install -y azure-cli 2>/dev/null || \
    warn "Azure CLI: sudo dnf install azure-cli (o ver docs.microsoft.com)"
fi

# Supabase CLI via npm
if command -v npm >/dev/null 2>&1; then
  npm install -g supabase 2>/dev/null || \
    sudo npm install -g supabase 2>/dev/null || \
    warn "supabase CLI no instalado"
fi

# uv (Python)
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh 2>/dev/null || warn "uv no instalado"
fi

# pnpm
if command -v corepack >/dev/null 2>&1; then
  sudo corepack enable 2>/dev/null || true
  corepack prepare pnpm@latest --activate 2>/dev/null || true
fi

# Cisco Packet Tracer — requiere .deb descargado de NetAcad
shopt -s nullglob
DEB_FILES=("$HOME/Downloads"/PacketTracer*.deb)
shopt -u nullglob
if ((${#DEB_FILES[@]})); then
  DEB_FILE="${DEB_FILES[0]}"
  log "Packet Tracer desde $DEB_FILE"
  sudo dnf install -y alien libicu 2>/dev/null || true
  if sudo alien -r "$DEB_FILE" 2>/dev/null; then
    sudo rpm -i packettracer*.rpm 2>/dev/null || warn "Packet Tracer: revisa dependencias manualmente"
    rm -f packettracer*.rpm 2>/dev/null || true
  else
    warn "alien falló al convertir Packet Tracer"
  fi
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

echo ""
echo "Dev tools listos. Cierra sesión para grupo docker (si aplica)."
