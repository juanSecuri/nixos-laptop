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

  environment.sessionVariables.JAVA_HOME = lib.mkDefault "${pkgs.jdk21}";
}
