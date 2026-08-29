{
  config,
  pkgs,
  lib,
  ...
}:
let
  cursorAppImage = "${config.home.homeDirectory}/.local/share/cursor/cursor.AppImage";
in
{
  # Cursor is distributed as AppImage — download once after install:
  #   mkdir -p ~/.local/share/cursor
  #   curl -L https://downloader.cursor.sh/linux/appImage/x64 -o ~/.local/share/cursor/cursor.AppImage
  #   chmod +x ~/.local/share/cursor/cursor.AppImage

  home.file.".local/share/applications/cursor.desktop".text = ''
    [Desktop Entry]
    Name=Cursor
    Comment=AI-powered code editor
    Exec=${cursorAppImage} --no-sandbox %F
    Icon=co.anysphere.cursor
    Type=Application
    StartupNotify=true
    StartupWMClass=Cursor
    Categories=Development;IDE;
    MimeType=text/plain;inode/directory;
    Actions=new-empty-window;

    [Desktop Action new-empty-window]
    Name=New Empty Window
    Exec=${cursorAppImage} --no-sandbox --new-window %F
  '';

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.file.".local/bin/cursor".text = ''
    #!${pkgs.bash}/bin/bash
    exec ${cursorAppImage} --no-sandbox "$@"
  '';
  home.file.".local/bin/cursor".executable = true;

  home.packages = with pkgs; [
    vscode
    neovim
    tree-sitter
  ];
}
