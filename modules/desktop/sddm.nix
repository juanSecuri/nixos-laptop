{
  pkgs,
  ...
}:
let
  # https://github.com/catppuccin/sddm — official Catppuccin SDDM (NixOS 24.11)
  catppuccinSddm = pkgs.catppuccin-sddm.override {
    flavor = "mocha";
    font = "JetBrainsMono Nerd Font";
    fontSize = "10";
    background = "${../../assets/wallpapers/wallpaper.jpg}";
    loginBackground = true;
  };
in
{
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      theme = "catppuccin-mocha";
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

  # Qt6 deps for SDDM greeter + Catppuccin theme
  environment.systemPackages = [
    catppuccinSddm
    pkgs.kdePackages.qtsvg
    pkgs.kdePackages.qtdeclarative
    pkgs.kdePackages.qt5compat
  ];
}
