{
  pkgs,
  ...
}:
{
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha";
    };
    defaultSession = "hyprland";
  };

  environment.systemPackages = [
    pkgs."catppuccin-sddm-corners"
  ];
}
