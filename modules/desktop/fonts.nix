{
  lib,
  pkgs,
  ...
}:
{
  fonts = {
    enableDefaultPackages = true;
    fontconfig.enable = true;
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "SymbolsOnly"
        ];
      })
      noto-fonts
      noto-fonts-color-emoji
      cantarell-fonts
    ];
  };
}
