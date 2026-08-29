{
  config,
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix

    ../../modules/hardware/amd-laptop.nix
    ../../modules/boot/systemd-boot.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/fonts.nix
    ../../modules/dev/python.nix
    ../../modules/dev/node.nix
    ../../modules/dev/java.nix
    ../../modules/dev/docker.nix
    ../../modules/dev/databases.nix
    ../../modules/dev/cloud-cli.nix
    ../../modules/networking/networkmanager.nix
    ../../modules/security/secrets.nix
  ];

  networking.hostName = "lenovo-v14";

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  services.flatpak.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = "Juan Esteban Gallego Loaiza";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "video"
      "audio"
    ];
    # Add your SSH public key before install (recommended):
    # docs/install/00-checklist.md
    openssh.authorizedKeys.keys = [
      # "ssh-ed25519 AAAA... jloaiza10@lenovo-v14"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-bak";
    extraSpecialArgs = {
      inherit inputs username;
    };
    users.${username} = import ../../home/${username};
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  system.stateVersion = "25.05";

  # Dev shells available via: nix develop .#python | nix develop .#node
}
