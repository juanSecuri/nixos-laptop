{
  lib,
  ...
}:
{
  boot.loader = {
    systemd-boot = {
      enable = lib.mkDefault true;
      editor = false;
    };
    efi.canTouchEfiVariables = lib.mkDefault true;
  };

  boot.loader.systemd-boot.configurationLimit = 10;
  boot.plymouth.enable = lib.mkDefault true;
}
