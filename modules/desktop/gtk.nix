{
  pkgs,
  ...
}:
{
  # Thunar + apps GTK usan tema oscuro Catppuccin de forma consistente
  environment.variables = {
    GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  environment.systemPackages = with pkgs; [
    gvfs
    tumbler
    gnome.gnome-themes-extra
  ];

  programs.dconf.enable = true;
}
