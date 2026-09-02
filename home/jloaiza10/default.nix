{ config, lib, pkgs, ... }:
let
  mocha = {
    base = "#1e1e2e";
    mantle = "#181825";
    surface0 = "#313244";
    surface1 = "#45475a";
    text = "#cdd6f4";
    subtext = "#a6adc8";
    lavender = "#b4befe";
    mauve = "#cba6f7";
    blue = "#89b4fa";
    green = "#a6e3a1";
    red = "#f38ba8";
    yellow = "#f9e2af";
  };
in
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./kitty.nix
    ./shell.nix
    ./git.nix
    ./cursor.nix
    ./faith.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./wlogout.nix
  ];

  home = {
    username = "jloaiza10";
    homeDirectory = "/home/jloaiza10";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  programs.dconf.enable = true;

  home.sessionVariables = {
    GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Catppuccin-Mocha-Standard-Blue-Dark";
      icon-theme = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Classic";
      font-name = "Cantarell 11";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    font = {
      name = "Cantarell";
      package = pkgs.cantarell-fonts;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-enable-primary-paste = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
  };

  services.mako = {
    enable = true;
    extraConfig = ''
      font=JetBrainsMono Nerd Font 10
      background-color=${mocha.mantle}
      text-color=${mocha.text}
      border-color=${mocha.mauve}
      border-size=2
      border-radius=10
      default-timeout=5000
      anchor=top-right
      margin=12
      padding=12
    '';
  };

  home.packages = with pkgs; [
    pkgs."catppuccin-gtk"
    pkgs."papirus-icon-theme"
    rofi
    wofi
    mako
    xfce.thunar
    pkgs."file-roller"
    pkgs."xdg-utils"
    pkgs."wl-clipboard"
    cliphist
    grim
    slurp
    playerctl
    brightnessctl
    pavucontrol
    blueman
    hyprpaper
    hyprlock
    hypridle
    wlogout
    gvfs
    tumbler
  ];
}
