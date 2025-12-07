{
  config,
  pkgs,
  lib,
  inputs,
  zen-browser,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/asus-kernel.nix
    ./pkgs
  ];

  # System State Version
  system.stateVersion = "25.05";

  # Nix Settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ]; # Nix Flakes
  nix.settings.max-jobs = lib.mkDefault 2; # limit parallel builds
  nix.settings.cores = lib.mkDefault 2; # limit build cores per job
  nix.settings.trusted-users = [ "parker" ];

  # Constrain nix-daemon with systemd cgroups to avoid system lockups during builds
  systemd.slices."nix-daemon" = {
    sliceConfig = {
      MemoryHigh = "60%"; # throttle when exceeding this
      MemoryMax = "80%"; # hard cap for all builds
      CPUQuota = "200%"; # at most ~2 cores across all builds
    };
  };
  systemd.services.nix-daemon.serviceConfig = {
    Slice = "nix-daemon.slice";
    OOMScoreAdjust = 500; # prefer killing builders over the desktop on OOM
    CPUAccounting = true;
    IOAccounting = true;
    MemoryAccounting = true;
  };

  # DDCUTIL Brightness Control
  users.groups.i2c = { };
  users.extraGroups.i2c.members = [ "parker" ];
  
  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="i2c-dev", KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';
  systemd.services.udevd.restartIfChanged = true;

  # SSH
  services.openssh.enable = true; # allows other devices to ssh into laptop

  # ============================================================================
  # BOOT CONFIGURATION - ALL CONSOLIDATED HERE
  # ============================================================================
  
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 5;  # 5 seconds to select boot options, set to 0 for instant boot
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS Encryption
  boot.initrd.luks.devices."luks-2cdebd65-326f-46c5-bfa0-753247f43f88".device =
    "/dev/disk/by-uuid/2cdebd65-326f-46c5-bfa0-753247f43f88";

  # Kernel Modules
  boot.kernelModules = [
    "i2c-dev"
    "asus_nb_wmi"
  ];
  
  # Load NVIDIA modules early for Plymouth support
  boot.initrd.kernelModules = [ 
    "nvidia" 
    "nvidia_modeset" 
    "nvidia_uvm" 
    "nvidia_drm" 
  ];

  boot.blacklistedKernelModules = [ "nouveau" ];

  # Consolidated Kernel Parameters - ALL IN ONE PLACE
  boot.kernelParams = [
    # Plymouth and quiet boot params
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    # NVIDIA and hardware params
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "acpi_backlight=native"
  ];

  # Plymouth Boot Splash Configuration
  boot.plymouth = {
    enable = true;
    theme = "rog_2";
    themePackages = with pkgs; [
      (adi1090x-plymouth-themes.override {
        selected_themes = [ "rog_2" ];
      })
    ];
  };
  # Silent/Quiet Boot Configuration
  boot.consoleLogLevel = 0;      # Suppress console messages
  boot.initrd.verbose = false;   # Quiet initrd

  # Sound driver configuration
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';

  # ============================================================================
  # DISPLAY MANAGER - greetd with tuigreet
  # ============================================================================
  
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";
  
  # Disable other display managers
  services.displayManager.gdm.enable = false;

  # greetd Configuration
  services.greetd = {
    enable = true;
    settings = {
      terminal = {
        vt = lib.mkForce 2;  # Use VT2 to avoid systemd message leakage, force override default
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --greeting 'Welcome to NixOS, Parker' --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # ============================================================================
  # VIRTUALIZATION
  # ============================================================================
  
  users.extraGroups.docker.members = [ "parker" ];
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  hardware.nvidia-container-toolkit.enable = true; # enable gpu passthrough w/ docker

  virtualisation.docker.daemon.settings = {
    userland-proxy = false;
    experimental = true;
    metrics-addr = "0.0.0.0:9323";
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # ============================================================================
  # PROGRAMS
  # ============================================================================
  
  programs.nano.enable = false; # remove nano (using helix instead)

  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs =
        pkgs: with pkgs; [
          xorg.libxshmfence # <- the missing fence library
        ];
    };
  };

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

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs.hyprland;
  };

  programs.steam.enable = true;

  # ============================================================================
  # NETWORKING
  # ============================================================================
  
  networking.hostName = "strixy";
  networking.networkmanager.enable = true;
  # networking.networkmanager.wait-online.enable = false;

  # ============================================================================
  # LOCALIZATION
  # ============================================================================
  
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

  # ============================================================================
  # XDG PORTALS
  # ============================================================================
  
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "gtk";

  # ============================================================================
  # AUDIO - PipeWire
  # ============================================================================
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.pipewire.wireplumber.enable = true;

  # ============================================================================
  # SECURITY
  # ============================================================================
  
  security.polkit.enable = true;
  security.rtkit.enable = true;

  # ============================================================================
  # SERVICES
  # ============================================================================
  
  services.printing.enable = true;
  services.samba.enable = true; # iPhone File support
  services.usbmuxd.enable = true; # iPhone File support
  services.udisks2.enable = true; # Auto detection and mounting of drives
  services.gvfs.enable = true; # Auto detection and mounting of drives
  services.ratbagd.enable = true; # Piper Mouse Configuration

  # Flatpak
  services.flatpak = {
    enable = true;
    packages = [
      "com.bambulab.BambuStudio"
      "com.revolutionarygamesstudio.ThriveLauncher"
    ];
  };

  # ============================================================================
  # BLUETOOTH
  # ============================================================================
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.package = pkgs.bluez;
  services.blueman.enable = true;

  # ============================================================================
  # USER CONFIGURATION
  # ============================================================================
  
  users.users.parker = {
    isNormalUser = true;
    description = "Parker";
    extraGroups = [
      "networkmanager"
      "wheel"
      "i2c"
      "disk"
      "video"
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs zen-browser; };
    backupFileExtension = "backup";
    users = {
      "parker" = import ./home.nix;
    };
  };

  # ============================================================================
  # NIXPKGS CONFIG
  # ============================================================================
  
  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  # ============================================================================
  # ENVIRONMENT
  # ============================================================================
  
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint electron apps to use Wayland
    WLR_NO_HARDWARE_CURSORS = "1";
    NH_FLAKE = "/home/parker/Desktop/dotfiles/nixos";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  environment.variables.LD_LIBRARY_PATH = lib.mkForce (
    with pkgs; lib.makeLibraryPath [ libxkbcommon ]
  );

  # System Packages
  environment.systemPackages =
    with pkgs;
    (
      (import ./packages.nix { inherit pkgs; })
      ++ [
        # greetd - FIXED: renamed from greetd.tuigreet to tuigreet
        tuigreet
        
        # Graphics and utilities
        libglvnd
        ddcutil
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        mesa
        libva-utils
        vdpauinfo
        
        # CUDA
        cudaPackages_12_8.cudatoolkit
        cudaPackages_12_8.cuda_nvcc
        cudaPackages_12_8.cuda_cudart
        cudaPackages_12_8.cuda_cupti
      ]
    );

  # ============================================================================
  # FONTS
  # ============================================================================
  
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    cantarell-fonts
    dejavu_fonts
    source-code-pro
    source-sans
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    font-awesome_5
  ];

  # ============================================================================
  # NVIDIA CONFIGURATION
  # ============================================================================
  
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware = {
    nvidia = {
      # NVIDIA-SMI 570.86.16 Driver Version: 570.86.16
      open = false; # Proprietary drivers
      # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #   version = "570.86.16";
      #   sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=y";
      #   openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
      #   settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
      #   usePersistenced = false;
      # };
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      nvidiaSettings = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true; # Enable fine-grained for offload mode
      modesetting.enable = true;
      dynamicBoost.enable = true;
      forceFullCompositionPipeline = true;
      # Use offload mode for better compatibility with display managers
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
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva-vdpau-driver
        libvdpau-va-gl
        nvidia-vaapi-driver
        intel-media-driver
        intel-vaapi-driver
        libglvnd
        mesa
      ];
    };
  };

  # ============================================================================
  # SPECIALISATIONS
  # ============================================================================
  
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
