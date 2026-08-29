{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    jdk21
    maven
    gradle
  ];

  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };
}
