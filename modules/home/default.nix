{ pkgs, username, ... }:
{
  imports = [
    ./hypr/default.nix
    ./quickshell/default.nix
    ./alacritty/default.nix
    ./fish/default.nix
    ./btop/btop.nix
    ./spicetify/spicetify.nix
    ./matugen/default.nix
    ./nvim/default.nix
    ./fastfetch/default.nix
    ./yazi.nix
    ./faith.nix
    ./git.nix
    ./cursor.nix
    ./dev.nix
    ./gtk.nix
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

  services.mako = {
    enable = true;
    extraConfig = ''
      font=JetBrainsMono Nerd Font 10
      background-color=#1e1e2e
      text-color=#cdd6f4
      border-color=#89b4fa
      border-size=1
      border-radius=8
      default-timeout=4000
      anchor=top-right
      margin=10
      padding=10
    '';
  };
}
