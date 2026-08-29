{
  lib,
  ...
}:
{
  # agenix integration — enable after generating age keys:
  #   age-keygen -o /etc/agenix/keys.txt
  #   agenix -e secrets/supabase.env.age
  #
  # age.secrets = {
  #   supabase-env = {
  #     file = ../secrets/supabase.env.age;
  #     owner = "jloaiza10";
  #     mode = "0400";
  #   };
  # };

  security.sudo.wheelNeedsPassword = lib.mkDefault true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
      X11Forwarding = false;
    };
  };
}
