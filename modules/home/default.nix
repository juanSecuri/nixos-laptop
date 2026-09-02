{ pkgs, username, ... }:
{
  imports = [
    ./hypr/default.nix
    ./quickshell/default.nix
    ./alacritty/default.nix
    ./fish/default.nix
    ./btop/btop.nix
    ./cava/default.nix
    ./spicetify/spicetify.nix
    ./matugen/default.nix
    ./nvim/default.nix
    ./fastfetch/default.nix
    ./yazi.nix
    ./faith.nix
    ./git.nix
    ./cursor.nix
    ./dev.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";
  home.enableNixpkgsReleaseCheck = false;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    wl-clipboard
    libnotify
    awww
    mako
  ];

  services.mako.enable = true;
}
