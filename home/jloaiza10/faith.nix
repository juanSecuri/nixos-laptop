{
  config,
  pkgs,
  ...
}:
let
  # Cambia por el canal Mixlr de "La Palabra del Señor"
  mixlrUrl = "https://ayudador.mixlr.com/";
  bibleUrl = "https://www.bible.com/es";
in
{
  home.packages = with pkgs; [
    firefox
    mpv
    pkgs."yt-dlp"
  ];

  home.file.".local/bin/la-palabra-del-senor".text = ''
    #!${pkgs.bash}/bin/bash
    exec ${pkgs.firefox}/bin/firefox --new-window "${mixlrUrl}"
  '';
  home.file.".local/bin/la-palabra-del-senor".executable = true;

  home.file.".local/bin/biblia".text = ''
    #!${pkgs.bash}/bin/bash
    exec ${pkgs.firefox}/bin/firefox --new-window "${bibleUrl}"
  '';
  home.file.".local/bin/biblia".executable = true;

  home.file.".local/share/applications/la-palabra-del-senor.desktop".text = ''
    [Desktop Entry]
    Name=La Palabra del Señor (Mixlr)
    Comment=Escuchar en vivo en Mixlr
    Exec=${config.home.homeDirectory}/.local/bin/la-palabra-del-senor
    Icon=audio-headphones
    Type=Application
    Categories=Audio;Network;
    StartupNotify=true
  '';

  home.file.".local/share/applications/biblia.desktop".text = ''
    [Desktop Entry]
    Name=Biblia (YouVersion)
    Comment=Lectura bíblica en el navegador
    Exec=${config.home.homeDirectory}/.local/bin/biblia
    Icon=bookmarks
    Type=Application
    Categories=Education;Network;
    StartupNotify=true
  '';
}
