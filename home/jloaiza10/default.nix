{ config, lib, pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./terminal.nix
    ./shell.nix
    ./git.nix
    ./cursor.nix
  ];

  home = {
    username = "jloaiza10";
    homeDirectory = "/home/jloaiza10";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

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
    };
    gtk4 = {
      theme = config.gtk.theme;
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
  };

  services.mako = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font 10";
      background-color = "#181825";
      text-color = "#cdd6f4";
      border-color = "#cba6f7";
      border-size = 2;
      border-radius = 10;
      default-timeout = 5000;
      anchor = "top-right";
      margin = "12";
      padding = "12";
    };
  };

  home.packages = with pkgs; [
    firefox
    thunar
    file-roller
    xdg-utils
    xdg-desktop-portal-hyprland
    wl-clipboard
    cliphist
    grim
    slurp
    playerctl
    brightnessctl
    pavucontrol
    blueman
  ];
}
