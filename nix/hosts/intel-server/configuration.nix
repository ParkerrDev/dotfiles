{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "jarvis";
  networking.networkmanager.enable = true;

  # Locale and timezone
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # Console keymap
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # User account - using hashedPasswordFile for reliability
  users.users.parker = {
    isNormalUser = true;
    description = "NixOS User";
    hashedPasswordFile = "/etc/nixos/user-password";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Root account - also set password file for emergency access
  users.users.root = {
    hashedPasswordFile = "/etc/nixos/root-password";
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Minimal system packages
  environment.systemPackages = with pkgs; [
    helix
    zellij
    nh
    blesh
    atuin
    lf
    fzf
    tree
    tldr
    lynx
    devenv
    gh
    git
  ];

  # Enable SSH for remote configuration
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";  # Allow root login for initial setup
      PasswordAuthentication = true;
    };
  };

  system.stateVersion = "25.05";
}
