#!/usr/bin/env bash
set -uo pipefail

MIXLR_URL="https://ayudador.mixlr.com/"
BIBLE_URL="https://www.bible.com/es"

mkdir -p "$HOME/.local/bin" "$HOME/.local/share/applications"

cat > "$HOME/.local/bin/la-palabra-del-senor" << EOF
#!/bin/bash
exec firefox --new-window "$MIXLR_URL"
EOF
chmod +x "$HOME/.local/bin/la-palabra-del-senor"

cat > "$HOME/.local/bin/biblia" << EOF
#!/bin/bash
exec firefox --new-window "$BIBLE_URL"
EOF
chmod +x "$HOME/.local/bin/biblia"

cat > "$HOME/.local/share/applications/la-palabra-del-senor.desktop" << EOF
[Desktop Entry]
Name=La Palabra del Señor (Mixlr)
Comment=Escuchar en vivo
Exec=$HOME/.local/bin/la-palabra-del-senor
Icon=audio-headphones
Type=Application
Categories=Audio;Network;
EOF

cat > "$HOME/.local/share/applications/biblia.desktop" << EOF
[Desktop Entry]
Name=Biblia (YouVersion)
Comment=Lectura bíblica
Exec=$HOME/.local/bin/biblia
Icon=bookmarks
Type=Application
Categories=Education;Network;
EOF

echo "Mixlr: SUPER+Shift+B | Biblia: SUPER+Shift+Y"
