# PLACEHOLDER — nixos-anywhere regenerates this during install.
# Do NOT add fileSystems or swapDevices here: disko.nix owns the disk layout.
{
  imports = [ ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-amd"
  ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
