{
  config,
  lib,
  pkgs,
  ...
}:
{
  # nixpkgs Hyprland only — avoids compiling flake/musl builds on live USB
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "breeze";
    };
    defaultSession = "hyprland";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "cursor";
    VISUAL = "cursor";
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  programs.dconf.enable = true;

  services.udev.packages = with pkgs; [
    gnome-settings-daemon
  ];

  environment.systemPackages = with pkgs; [
    catppuccin-gtk
    papirus-icon-theme
    qt6Packages.qt6ct
    libsForQt5.qt5ct
    glib
    dconf
    wlr-randr
    brightnessctl
    playerctl
    pavucontrol
    mako
    rofi
    waybar
    wofi
    grim
    slurp
    wl-clipboard
    cliphist
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-color-emoji
    font-awesome
  ];
}
