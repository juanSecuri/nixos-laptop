#!/usr/bin/env bash
set -euo pipefail

CURSOR_DIR="$HOME/.local/share/cursor"
CURSOR_BIN="$CURSOR_DIR/cursor.AppImage"

mkdir -p "$CURSOR_DIR" "$HOME/.local/bin"

if [[ ! -f "$CURSOR_BIN" ]]; then
  echo "Descargando Cursor AppImage..."
  curl -L "https://downloader.cursor.sh/linux/appImage/x64" -o "$CURSOR_BIN"
  chmod +x "$CURSOR_BIN"
fi

cat > "$HOME/.local/bin/cursor" << EOF
#!/bin/bash
exec "$CURSOR_BIN" --no-sandbox "\$@"
EOF
chmod +x "$HOME/.local/bin/cursor"

cat > "$HOME/.local/share/applications/cursor.desktop" << EOF
[Desktop Entry]
Name=Cursor
Comment=AI code editor
Exec=$CURSOR_BIN --no-sandbox %F
Icon=co.anysphere.cursor
Type=Application
Categories=Development;IDE;
StartupWMClass=Cursor
EOF

KEYBINDS="$HOME/.config/hypr/UserConfigs/UserKeybinds.conf"
mkdir -p "$(dirname "$KEYBINDS")"
if ! grep -q "cursor" "$KEYBINDS" 2>/dev/null; then
  cat >> "$KEYBINDS" << 'EOF'

# Dev — Cursor IDE
bind = $mainMod SHIFT, C, exec, cursor
EOF
fi

echo "Cursor instalado: cursor | SUPER+Shift+C"
