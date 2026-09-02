{
  pkgs,
  ...
}:
{
  fonts = {
    enableDefaultPackages = true;
    fontconfig.enable = true;
    packages = [
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      pkgs."noto-fonts"
      pkgs."noto-fonts-color-emoji"
      pkgs."cantarell-fonts"
      pkgs."font-awesome"
    ];
  };
}
