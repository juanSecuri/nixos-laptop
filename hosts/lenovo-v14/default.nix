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

    ../../modules/hardware/laptop.nix
    ../../modules/boot/boot.nix
    ../../modules/desktop/default.nix
    ../../modules/dev/default.nix
    ../../modules/system/networking.nix
    ../../modules/system/locale.nix
    ../../modules/system/security.nix
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

  nixpkgs.config = {
    allowUnfree = true;
    doDoc = false;
  };

  documentation = {
    enable = lib.mkDefault false;
    man.enable = lib.mkDefault false;
    info.enable = lib.mkDefault false;
  };

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
    # Añade tu clave SSH antes de instalar (recomendado):
    # openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAA... jloaiza10@lenovo-v14" ];
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
    curl
    git
  ];

  system.stateVersion = "24.11";
}
