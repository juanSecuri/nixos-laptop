{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            name = "ESP";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "defaults"
                "umask=077"
              ];
            };
          };
          swap = {
            name = "swap";
            size = "16G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [
                "-f"
                "-L"
                "nixos"
              ];
              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                };
                "@home" = {
                  mountpoint = "/home";
                };
                "@nix" = {
                  mountpoint = "/nix";
                };
                "@log" = {
                  mountpoint = "/var/log";
                };
              };
              mountOptions = [
                "compress=zstd"
                "noatime"
                "space_cache=v2"
              ];
            };
          };
        };
      };
    };
  };
}
