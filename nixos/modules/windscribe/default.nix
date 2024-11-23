{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.windscribe;
in {
  options.services.windscribe = {
    enable = mkEnableOption "Windscribe VPN";
    
    package = mkOption {
      type = types.package;
      default = pkgs.callPackage ./package.nix {};
      description = "The Windscribe package to use.";
    };

    autoStart = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to auto-start the Windscribe service on boot.";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
    
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];
    
    networking.networkmanager.enable = true;

    security.polkit.enable = true;

    systemd.tmpfiles.rules = [
      "d /var/log/windscribe 0755 root root -"
      "d /var/lib/windscribe 0755 root root -"
    ];

    environment.etc = {
      "windscribe/cert.pem".source = "${cfg.package}/etc/windscribe/cert.pem";
      "windscribe/cgroups-down".source = "${cfg.package}/etc/windscribe/cgroups-down";
      "windscribe/cgroups-up".source = "${cfg.package}/etc/windscribe/cgroups-up";
      "windscribe/dns-leak-protect".source = "${cfg.package}/etc/windscribe/dns-leak-protect";
      "windscribe/install-update".source = "${cfg.package}/etc/windscribe/install-update";
      "windscribe/update-network-manager".source = "${cfg.package}/etc/windscribe/update-network-manager";
      "windscribe/update-resolv-conf".source = "${cfg.package}/etc/windscribe/update-resolv-conf";
      "windscribe/update-systemd-resolved".source = "${cfg.package}/etc/windscribe/update-systemd-resolved";
    };

    systemd.services.windscribe-helper = mkIf cfg.autoStart {
      wantedBy = [ "multi-user.target" ];
    };

    systemd.user.services.windscribe = mkIf cfg.autoStart {
      wantedBy = [ "default.target" ];
    };
  };
}