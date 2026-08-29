{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    nodejs_22
    nodePackages.pnpm
    nodePackages.corepack
    nodePackages.typescript
    nodePackages.typescript-language-server
    yarn
  ];

  programs.corepack.enable = true;
}
