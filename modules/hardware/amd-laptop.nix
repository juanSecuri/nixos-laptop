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
    loader.systemd-boot.configurationLimit = 10;
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault true;
    enableRedistributableFirmware = true;
    firmware = with pkgs; [
      linux-firmware
      # RTL8852BE (Wi-Fi 6) — firmware included in linux-firmware since nixpkgs 25.11+
    ];
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  services = {
    fwupd.enable = true;
    thermald.enable = true;
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };

  # Laptop power / suspend
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "ignore";
    HandlePowerKey = "suspend";
  };

  boot.kernelModules = lib.mkAfter [
    "snd_hda_intel"
  ];

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Prefer recent kernel for rtw89 / amdgpu on Ryzen 7730U
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
}
