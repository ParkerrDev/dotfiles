{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "jarvis";
  networking.networkmanager.enable = true;

  # Only expose SSH. No inbound HTTPS needed with Cloudflare Tunnel.
  networking.firewall.allowedTCPPorts = [ 2222 1024 ];

  # Optional: improve QUIC performance / silence UDP buffer warning from cloudflared
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 8388608;
    "net.core.wmem_max" = 8388608;
  };

  # Locale and timezone
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # Console keymap
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # User account
  users.users.parker = {
    isNormalUser = true;
    description = "NixOS User";
    hashedPasswordFile = "/etc/nixos/user-password";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Root account
  users.users.root.hashedPasswordFile = "/etc/nixos/root-password";

  nix.settings = {
    trusted-users = [ "root" "parker" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Disable programs I don't need
  programs.nano.enable = false;

  # System packages
  environment.systemPackages = with pkgs; [
    helix
    zellij
    nh
    blesh
    lf
    fzf
    tree
    tldr
    lynx
    devenv
    gh
    git
    zola
    kitty
    alacritty
    home-manager
    cloudflared
  ];

  #
  # Atuin server — bind only to localhost; Cloudflare Tunnel will publish it
  #
  users.users.atuin = {
    isSystemUser = true;
    description = "Atuin synchronized shell history";
    group = "atuin";
    home = "/var/lib/atuin";
    createHome = true;
  };
  users.groups.atuin = {};

  environment.etc."atuin/server.toml".text = ''
    host = "127.0.0.1"
    port = 8888
    open_registration = false
    db_uri = "sqlite:///var/lib/atuin/atuin.db"
  '';

  systemd.services.atuin-server = {
    description = "Atuin server syncing service";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    preStart = ''
      mkdir -p /var/lib/atuin
      chown -R atuin:atuin /var/lib/atuin
      chmod 0750 /var/lib/atuin

      if [ -f /var/lib/atuin/atuin.db ]; then
        chown atuin:atuin /var/lib/atuin/atuin.db
        chmod 0640 /var/lib/atuin/atuin.db
      fi
    '';

    serviceConfig = {
      ExecStart = "${pkgs.atuin}/bin/atuin server start";
      Restart = "on-failure";
      RestartSec = "10s";
      User = "atuin";
      Group = "atuin";

      Environment = [ "ATUIN_CONFIG_DIR=/etc/atuin" ];

      StateDirectory = "atuin";
      StateDirectoryMode = "0750";

      # Hardening
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;

      ReadWritePaths = [ "/var/lib/atuin" ];
      ReadOnlyPaths = [ "/etc/atuin" ];
    };
  };

  #
  # Cloudflare Tunnel — expose atuin.parkerhunt.me -> http://127.0.0.1:8888
  # Declarative config per https://nixos.wiki/wiki/Cloudflared
  #
  services.cloudflared = {
    enable = true;

    tunnels = {
      # Use your tunnel UUID as the key (matches wiki pattern)
      "460c7d18-93af-4714-9bba-2bce09788f4d" = {
        # Credentials file you installed from `cloudflared tunnel create atuin`
        credentialsFile = "/var/lib/cloudflared/atuin.json";

        # Ingress rules: hostname -> service
        ingress = {
          "atuin.parkerhunt.me" = "http://127.0.0.1:8888";
        };

        # Fallback for unmatched hostnames
        default = "http_status:404";
      };
    };
  };

  # Ensure credentials directory and file exist with correct perms
  systemd.tmpfiles.rules = [
    "d /var/lib/cloudflared 0750 root root - -"
    "z /var/lib/cloudflared/atuin.json 0640 root root - -"
  ];

  # SSH
  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  system.stateVersion = "25.05";
}
