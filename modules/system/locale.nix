{
  lib,
  ...
}:
{
  time.timeZone = lib.mkDefault "America/Bogota";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb = {
    layout = lib.mkDefault "latam";
    variant = lib.mkDefault "";
  };

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
