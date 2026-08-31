{
  lib,
  ...
}:
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = lib.mkDefault false;
      PermitRootLogin = lib.mkDefault "prohibit-password";
      X11Forwarding = false;
    };
  };

  security.sudo.wheelNeedsPassword = lib.mkDefault true;
}
