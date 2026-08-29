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
        3000 # Next.js dev
        5173 # Vite dev
        8000 # FastAPI dev
        5678 # n8n
      ];
    };
  };

  networking.hostName = lib.mkDefault "lenovo-v14";
  time.timeZone = lib.mkDefault "America/Bogota";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CO.UTF-8";
    LC_IDENTIFICATION = "es_CO.UTF-8";
    LC_MEASUREMENT = "es_CO.UTF-8";
    LC_MONETARY = "es_CO.UTF-8";
    LC_NAME = "es_CO.UTF-8";
    LC_NUMERIC = "es_CO.UTF-8";
    LC_PAPER = "es_CO.UTF-8";
    LC_TELEPHONE = "es_CO.UTF-8";
    LC_TIME = "es_CO.UTF-8";
  };
}
