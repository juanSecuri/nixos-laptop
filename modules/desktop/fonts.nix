{
  pkgs,
  ...
}:
{
  fonts = {
    enableDefaultPackages = true;
    fontconfig.enable = true;
    packages = [
      pkgs.nerdfonts.jetbrains-mono
      pkgs.nerdfonts.symbols-only
      pkgs."noto-fonts"
      pkgs."noto-fonts-color-emoji"
      pkgs."cantarell-fonts"
      pkgs."font-awesome"
    ];
  };
}
