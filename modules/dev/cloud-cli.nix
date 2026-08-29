{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    git
    gh
    git-lfs
    delta
    lazygit
    # Cloud CLIs
    azure-cli
    # General utilities
    curl
    wget
    jq
    yq-go
    httpie
    ripgrep
    fd
    bat
    eza
    fzf
    tmux
    htop
    btop
    unzip
    zip
    gnupg
    openssh
    age
    sops
    nixfmt-rfc-style
  ];

  programs.gh.enable = true;
}
