{ config, pkgs, lib, inputs, outputs, pkgs_unstable, ... }:

{
  # ASUS G14 Patched Kernel based off of Arch Linux Kernel
  boot.kernelPackages =
    let
      linux_g14_pkg =
        { fetchurl, fetchzip, fetchgit, buildLinux, ... }@args:

        buildLinux (
          args
          // rec {
            version = "6.13.2-arch1";
            modDirVersion = version;

            patch_dir = fetchgit {
              url = "https://aur.archlinux.org/linux-g14.git";
              rev = "98b878245815c15420385f04cf5f3061314d06b0";
              hash = "sha256-BEteBZx1pio9Q+FqPsLR+I229ZqBk3QFravNle51XWc=";
            };

            src = fetchzip {
              url = "https://github.com/archlinux/linux/archive/refs/tags/v${version}.tar.gz";
              hash = "sha256-iBhhJlA+6J7UH69wmc4WJGMWog0UJoQVFDyLfQio7Po=";
            };
            kernelPatches =
              [
                {
                  name = "0000-asus-patch-series.patch";
                  patch = ../patches/asus-patch-series.patch;
                }
                {
                  name = "0001-acpi-proc-idle-skip-dummy-wait.patch";
                  patch = "${patch_dir}/0001-acpi-proc-idle-skip-dummy-wait.patch";
                }
                # {
                #   name = "0002-mt76_-mt7921_-Disable-powersave-features-by-default.patch";
                #   patch = "${patch_dir}/0002-mt76_-mt7921_-Disable-powersave-features-by-default.patch";
                # }
                {
                  name = "0004-ACPI-resource-Skip-IRQ-override-on-ASUS-TUF-Gaming-A.patch";
                  patch = "${patch_dir}/0004-ACPI-resource-Skip-IRQ-override-on-ASUS-TUF-Gaming-A.patch";
                }
                {
                  name = "0005-ACPI-resource-Skip-IRQ-override-on-ASUS-TUF-Gaming-A.patch";
                  patch = "${patch_dir}/0005-ACPI-resource-Skip-IRQ-override-on-ASUS-TUF-Gaming-A.patch";
                }
                # {
                #   name = "0006-mediatek-pci-reset.patch";
                #   patch = "${patch_dir}/0006-mediatek-pci-reset.patch";
                # }
                {
                  name = "0007-workaround_hardware_decoding_amdgpu.patch";
                  patch = "${patch_dir}/0007-workaround_hardware_decoding_amdgpu.patch";
                }
                {
                  name = "0008-amd-tablet-sfh.patch";
                  patch = "${patch_dir}/0008-amd-tablet-sfh.patch";
                }
                {
                  name = "0009-asus-nb-wmi-Add-tablet_mode_sw-lid-flip.patch";
                  patch = "${patch_dir}/0009-asus-nb-wmi-Add-tablet_mode_sw-lid-flip.patch";
                }
                {
                  name = "0010-asus-nb-wmi-fix-tablet_mode_sw_int.patch";
                  patch = "${patch_dir}/0010-asus-nb-wmi-fix-tablet_mode_sw_int.patch";
                }
                {
                  name = "0011-amdgpu-adjust_plane_init_off_by_one.patch";
                  patch = "${patch_dir}/0011-amdgpu-adjust_plane_init_off_by_one.patch";
                }
              ];

            defconfig = "${patch_dir}/config";
          }
          // (args.argsOverride or { })
        );
      linux_g14 = pkgs.callPackage linux_g14_pkg { };
    in
    pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_g14);

  services = {
    # ASUS Specific Software
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
      package = pkgs_unstable.asusctl;
    };

    # Dependency of asusd
    power-profiles-daemon.enable = true;
  };
}
