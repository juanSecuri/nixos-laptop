{
  pkgs,
  ...
}:
let
  wallpaper = ../../assets/wallpapers/wallpaper.jpg;

  # https://github.com/khaneliman/catppuccin-sddm-corners — rounded login panel
  lenovoSddmTheme = pkgs.runCommand "lenovo-v14-sddm" {
    propagatedBuildInputs = pkgs.catppuccin-sddm-corners.propagatedBuildInputs;
  } ''
    mkdir -p $out/share/sddm/themes/lenovo-v14-sddm/backgrounds
    cp -r ${pkgs.catppuccin-sddm-corners}/share/sddm/themes/catppuccin-sddm-corners/* \
      $out/share/sddm/themes/lenovo-v14-sddm/
    cp ${wallpaper} $out/share/sddm/themes/lenovo-v14-sddm/backgrounds/wallpaper.jpg

    substituteInPlace $out/share/sddm/themes/lenovo-v14-sddm/theme.conf \
      --replace 'Background="backgrounds/flatppuccin_macchiato.png"' \
                 'Background="backgrounds/wallpaper.jpg"' \
      --replace 'Font="Liga SFMono Nerd Font"' \
                 'Font="JetBrainsMono Nerd Font"' \
      --replace 'CornerRadius="5"' 'CornerRadius="18"' \
      --replace 'GeneralFontSize="9"' 'GeneralFontSize="10"' \
      --replace 'LoginScale="0.175"' 'LoginScale="0.2"' \
      --replace 'UserPictureBorderColor="#c0caf5"' 'UserPictureBorderColor="#cba6f7"' \
      --replace 'TextFieldHighlightColor="#c0caf5"' 'TextFieldHighlightColor="#cba6f7"' \
      --replace 'LoginButtonBgColor="#c0caf5"' 'LoginButtonBgColor="#cba6f7"' \
      --replace 'PopupBgColor="#c0caf5"' 'PopupBgColor="#313244"' \
      --replace 'PopupHighlightColor="#414868"' 'PopupHighlightColor="#cba6f7"'
  '';
in
{
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      theme = "lenovo-v14-sddm";
      settings = {
        General = {
          Numlock = "on";
          GreeterEnvironment = "QT_WAYLAND_DISABLE_WINDOWDECORATION=1";
        };
        Theme = {
          CursorTheme = "Bibata-Modern-Classic";
          CursorSize = "24";
        };
        Users = {
          MaximumUid = 2000;
          HideUsers = "nixbld,sddm";
        };
      };
    };
    defaultSession = "hyprland";
  };

  environment.systemPackages = [
    lenovoSddmTheme
    pkgs.catppuccin-sddm-corners
    pkgs.kdePackages.qtsvg
    pkgs.kdePackages.qtdeclarative
    pkgs.kdePackages.qt5compat
  ];
}
