{
  lib,
  ...
}:
{
  boot.loader = {
    systemd-boot.enable = lib.mkDefault true;
    efi.canTouchEfiVariables = lib.mkDefault true;
    systemd-boot.configurationLimit = 10;
  };

  boot.plymouth.enable = lib.mkDefault true;
}
