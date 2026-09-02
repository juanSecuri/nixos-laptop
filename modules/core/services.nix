{ ... }:
{
  services.xserver.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.printing.enable = true;
  services.usbmuxd.enable = true;
  services.blueman.enable = false;

  security.polkit.enable = true;
}
