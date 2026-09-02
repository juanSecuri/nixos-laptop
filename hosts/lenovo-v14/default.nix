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

    ../../modules/core
    ../../modules/hardware/laptop.nix
    ../../modules/boot/boot.nix
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
    # First boot / fresh install. Change with: passwd
    initialHashedPassword = "$6$K9m.WagzaNM30RTK$Z4r/WaxvNjo9y.tazz/qC62em4RfU12MtesrPdUX2.v3q50OWebNrrmYwtT5QwQRaahuoufIz/TZwomyyAMLY0";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-bak";
    extraSpecialArgs = {
      inherit inputs username;
    };
    users.${username}.imports = [
      ../../modules/home
      inputs.spicetify-nix.homeManagerModules.default
    ];
  };

  system.stateVersion = "24.11";
}
