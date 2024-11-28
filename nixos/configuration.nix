{ config, pkgs, lib, inputs, unstable, stable, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./pkgs
  ];

  # System State Version
  system.stateVersion = "24.11";

  # Nix Settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Nix Flakes


  # DDCUTIL Brightness Control
  users.groups.i2c = { };
  boot.kernelModules = [ "i2c-dev" ];
  services.udev.extraRules = ''
    SUBSYSTEM=="i2c-dev", KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0777"
  '';

  services.udev.enable = true;
  systemd.services.udevd.restartIfChanged = true;


  # Bootloader Configuration1
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 60;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-2cdebd65-326f-46c5-bfa0-753247f43f88".device =
    "/dev/disk/by-uuid/2cdebd65-326f-46c5-bfa0-753247f43f88";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';
  # boot.initrd.availableKernelModules = [ "mt76x2u" ];
  # # boot.extraModulePackages = [ pkgsmypackages.mt7961 ];
  # hardware.usb-modeswitch.enable = true;

  #Virtualization

  users.extraGroups.docker.members = [ "parker" ];
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  hardware.nvidia-container-toolkit.enable = true; # enable gpu passtrhough w/ docker


  virtualisation.docker.daemon.settings = {
    userland-proxy = false;
    experimental = true;
    metrics-addr = "0.0.0.0:9323";
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;



  # virtualisation.virtualbox.host.enable = true; # Causes build failures
  # virtualisation.virtualbox.guest.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  # Networking Configuration
  networking.hostName = "strixy";
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  #Proxy
  #networking.proxy.default = "http://172.20.10.1:9877";

  programs.proxychains = {
    enable = true;
    quietMode = false;
    proxies = {
      local = {
        enable = true;
        type = "socks5";
        host = "172.20.10.1";
        port = 9876;
      };
    };
  };

  # Time and Locale Configuration
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "gtk";

  # X11 and Display Manager Configuration
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";

  # security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  #hardware.pulseaudio.package = pkgs.pulseaudioFull;
  #nixpkgs.config.pulseaudio = true;
  #hardware.pulseaudio.enable = true;
  #hardware.pulseaudio.support32Bit = true;

  # Security and Polkit Configuration
  security.polkit.enable = true;
  security.rtkit.enable = true;

  # Printing Configuration
  services.printing.enable = true;

  # User Configuration
  users.users.parker = {
    isNormalUser = true;
    description = "Parker";
    extraGroups = [ "networkmanager" "wheel" "i2c" "asusd" ]; # Added input and video groups
    packages = with pkgs; [ brightnessctl ];
  };

  # Create asusd group
  users.groups.asusd = { };

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = { inherit inputs; };
    users = { "parker" = import ./home.nix; };
  };

  # Allow Unfree Packages
  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;

  services.samba.enable = true; # iPhone File support (i think)
  services.usbmuxd.enable = true; # iPhone File support (i think)

  services.flatpak.enable = true;

  services.udisks2.enable = true; # Auto detection and mounting of drives
  services.gvfs.enable = true; # Auto detection and mounting of drives

  services.asusd = {
    enable = true;
    enableUserService = true;
    package = stable.asusctl;
  };
  services.supergfxd.enable = true;
  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  services.ratbagd.enable = true; # Piper Mouse Configuration

  hardware.enableAllFirmware = true; # trying to fix sound - didnt fix

  services.windscribe = {
   enable = true;
   autoStart = true;  # Optional: set to false if you don't want it to start automatically
  };


  # Bluetooth and blueman-applet
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.package = pkgs.bluez;
  hardware.bluetooth.powerOnBoot = true;

  # stylix.enable = false;
  # stylix.image = /home/parker/Pictures/52259221868_3d2963c1fe_o.png;
  # stylix.polarity = "dark";

  programs.dconf.enable = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Environment Variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint electron apps to use Wayland. Must disable hardware acceleration to work properly.
    WLR_NO_HARDWARE_CURSORS = "1";
    #ALL_PROXY = "http://172.20.10.1:9877";
  };

  # Import the packages from packages.nix
  environment.systemPackages = import ./packages.nix pkgs;

  # environment.etc."proxychains.conf".text =
  # ''
  # config here
  # '';

  # Fonts Packages
  fonts.packages = with pkgs; [
    # font-awesome
    noto-fonts
    #noto-fonts-cjk - rog-control-center possibly not working because of this being deprecated
    noto-fonts-cjk-sans
    noto-fonts-emoji
    cantarell-fonts
    dejavu_fonts
    source-code-pro # Default monospace font in 3.32
    source-sans
    nerdfonts
    font-awesome_5
  ];

  # Gaming and NVIDIA Configuration
  services.xserver.videoDrivers = [ "intel" "nvidia" ];

  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
  #   version = "550.78";
  #   sha256_64bit = "sha256-NAcENFJ+ydV1SD5/EcoHjkZ+c/be/FQ2bs+9z+Sjv3M=";
  #   sha256_aarch64 = "sha256-2POG5RWT2H7Rhs0YNfTGHO64Q8u5lJD9l/sQCGVb+AA=";
  #   openSha256 = "sha256-cF9omNvfHx6gHUj2u99k6OXrHGJRpDQDcBG3jryf41Y=";
  #   settingsSha256 = "sha256-lZiNZw4dJw4DI/6CI0h0AHbreLm825jlufuK9EB08iw=";
  #   persistencedSha256 = "sha256-qDGBAcZEN/ueHqWO2Y6UhhXJiW5625Kzo1m/oJhvbj4=";
  # };

  # Driver Version: 550.78 CUDA Version: 12.4 [WORKING]
  # Driver Version: 550.107.02 CUDA Version: 12.4 [WORKING]
  # Driver Version: 555.58.02 CUDA Version 12.5 [CAUSES ISSUES]
  # nixos-unstable nvidia-open does not include nvidia-* commands which breaks everything


  # services.picom.vSync = true;
  hardware = {
    nvidia = {
      open = false; # the open source drivers suck balls
      package = config.boot.kernelPackages.nvidiaPackages.production;
      #package = config.boot.kernelPackages.nvidiaPackages.stable; # 560 Driver
      nvidiaSettings = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      modesetting.enable = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    graphics = {
      enable = true;
      #driSupport = true;
      #driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
    };
  };

  specialisation = {
    ios-proxy.configuration = {
      networking.proxy.default = "http://172.20.10.1:9877";
      environment.sessionVariables = {
        ALL_PROXY = "http://172.20.10.1:9877";
      };
    };
    gaming-time.configuration = {
      hardware.nvidia = {
        powerManagement.finegrained = lib.mkForce false;
        prime.sync.enable = lib.mkForce true;
        prime.offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
      };
    };
  };
}
