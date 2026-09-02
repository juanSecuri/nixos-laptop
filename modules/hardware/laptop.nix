{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-gpu-amd
  ];

  boot = {
    kernelParams = [
      "amdgpu.backlight=0"
      "acpi_osi=Linux"
    ];
    # linuxPackages (not _latest) — better binary cache coverage on live USB install
    kernelPackages = lib.mkDefault pkgs.linuxPackages;
    kernelModules = lib.mkAfter [ "snd_hda_intel" ];
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault true;
    enableRedistributableFirmware = true;
    firmware = with pkgs; [ linux-firmware ];
    bluetooth.enable = true;
    graphics = {
      enable = true;
      # Off during install — avoids building mesa 32-bit on space-limited live USB.
      # Enable later with: rebuild after setting enable32Bit = true
      enable32Bit = false;
    };
  };

  services = {
    fwupd.enable = true;
    thermald.enable = true;
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "ignore";
    powerKey = "suspend";
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
