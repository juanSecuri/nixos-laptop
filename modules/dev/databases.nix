{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    postgresql_16
    sqlite
    sqlfluff
    pkgs."supabase-cli"
    pgcli
  ];

  services.postgresql = {
    enable = lib.mkDefault false;
    package = pkgs.postgresql_16;
    enableJIT = true;
  };
}
