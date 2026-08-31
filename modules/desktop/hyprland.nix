{
  pkgs,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  security.polkit.enable = true;
  programs.dconf.enable = true;

  # Servicios mínimos GNOME (keyring + udev) — NO es el escritorio GNOME
  services.gnome.gnome-keyring.enable = true;
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  environment.systemPackages = with pkgs; [
    glib
    dconf
    wlr-randr
    qt6Packages.qt6ct
    libsForQt5.qt5ct
  ];
}
