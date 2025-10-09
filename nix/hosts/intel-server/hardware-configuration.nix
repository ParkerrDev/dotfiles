{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/359e9ed5-2750-4e2b-a9a4-1b7526de482e";
      fsType = "btrfs";
      options = [ "rw" "relatime" "compress=zstd:3" "nossd" "discard=async" "space_cache=v2" "subvol=/@" ];
    };

  fileSystems."/.snapshots" =
    { device = "/dev/disk/by-uuid/359e9ed5-2750-4e2b-a9a4-1b7526de482e";
      fsType = "btrfs";
      options = [ "rw" "relatime" "compress=zstd:3" "nossd" "discard=async" "space_cache=v2" "subvol=/@.snapshots" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/359e9ed5-2750-4e2b-a9a4-1b7526de482e";
      fsType = "btrfs";
      options = [ "rw" "relatime" "compress=zstd:3" "nossd" "discard=async" "space_cache=v2" "subvol=/@nix" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/359e9ed5-2750-4e2b-a9a4-1b7526de482e";
      fsType = "btrfs";
      options = [ "rw" "relatime" "compress=zstd:3" "nossd" "discard=async" "space_cache=v2" "subvol=/@home" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/359e9ed5-2750-4e2b-a9a4-1b7526de482e";
      fsType = "btrfs";
      options = [ "rw" "relatime" "compress=zstd:3" "nossd" "discard=async" "space_cache=v2" "subvol=/@log" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0F93-75E8";
      fsType = "vfat";
      options = [ "rw" "relatime" "fmask=0022" "dmask=0022" "codepage=437" "iocharset=ascii" "shortname=mixed" "utf8" "errors=remount-ro" ];
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/359e9ed5-2750-4e2b-a9a4-1b7526de482e";
      fsType = "btrfs";
      options = [ "subvol=/@swap" ];
    };
  swapDevices = [ { device = "/swap/swapfile"; } ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
