{
  lib,
  ...
}:
{
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
    firewall = {
      enable = lib.mkDefault true;
      allowedTCPPorts = [
        3000
        5173
        8000
        5678
      ];
    };
  };
}
