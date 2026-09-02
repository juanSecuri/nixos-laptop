{ inputs, ... }:
{
  imports = [
    ./services.nix
    ./fonts.nix
    ./packages.nix
    ./ly.nix
    ./hyprland.nix
    ./portals.nix
  ];
}
