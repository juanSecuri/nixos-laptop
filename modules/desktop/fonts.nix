{
  pkgs,
  ...
}:
{
  fonts = {
    enableDefaultPackages = true;
    fontconfig.enable = true;
    packages = [
      pkgs."nerd-fonts".jetbrains-mono
      pkgs."nerd-fonts"."symbols-only"
      pkgs."noto-fonts"
      pkgs."noto-fonts-color-emoji"
      pkgs."cantarell-fonts"
      pkgs."font-awesome"
    ];
  };
}
