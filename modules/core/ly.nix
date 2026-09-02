{ lib, ... }:
{
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "none";
      bigclock = false;
      hide_borders = true;
    };
  };
}
