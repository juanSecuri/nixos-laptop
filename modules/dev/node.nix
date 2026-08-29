{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    nodejs_22
    pnpm
    corepack
    typescript
    typescript-language-server
    yarn
  ];
}
