{ config, lib, pkgs, inputs, ... }:
let
  inherit (pkgs) writeShellScript;
in
{
  imports = [
    # inputs.ags.homeManagerModules.default
    ./modules/waybar/waybar.nix
    ./modules/wlogout/wlogout.nix
    ./modules/wofi/wofi.nix
    ./modules/hypr/hyprland.nix   # Added hyprland module
  ];

  home.username = "parker";
  home.homeDirectory = "/home/parker";
  home.stateVersion = "24.11";
  home.packages = [
    pkgs.waybar
  ];
  home.file = { };
  home.sessionVariables = {
    PRIMARY_MONITOR = "eDP-1";
    # Hardware acceleration variables (user-level, safe)
    __GL_THREADED_OPTIMIZATIONS = "1";
    __GL_SYNC_TO_VBLANK = "0";
    # VA-API variables
    LIBVA_DRIVER_NAME = "nvidia";
    # Vulkan variables
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_layers.json";
    # Mesa variables
    MESA_GL_VERSION_OVERRIDE = "4.6";
    MESA_GLSL_VERSION_OVERRIDE = "460";
  };

  home.enableNixpkgsReleaseCheck = false;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = lib.mkForce "Zorin-Mint-Light";
    };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  programs.home-manager.enable = true; # Let Home Manager install and manage itself.

  home.file.".config/gtk-3.0/settings.ini".text =
    ''
      [Settings]
      gtk-theme-name = Zorin-Mint-Light
      gtk-application-prefer-dark-theme = true
    '';

  home.file.".config/gtk-4.0/settings.ini".text =
    ''
      [Settings]
      gtk-theme-name = Zorin-Mint-Light
      gtk-application-prefer-dark-theme = true
    '';

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 22;
  };

  # programs.ags = {
  #   enable = true;

  #   # null or path, leave as null if you don't want hm to manage the config
  #   configDir = ../ags;

  #   # additional packages to add to gjs's runtime
  #   extraPackages = with pkgs; [
  #     gtksourceview
  #     webkitgtk
  #     accountsservice
  #   ];
  # };

  home.sessionVariables.GTK_THEME = "Zorin-Mint-Light";

  programs.atuin = {
  enable = true;
  enableBashIntegration = true;
  
  settings = {
    sync_address = "https://atuin.parkerhunt.me";  # Replace with jarvis's actual IP
    
    auto_sync = true;
    sync_frequency = "1m";
    search_mode = "fuzzy";
    style = "compact";
    show_preview = true;
    filter_mode_shell_up_key_binding = "global";
    sync_on_cd = true;       # Sync when changing directories
    update_on_sync = true;   # Update local db immediately on sync
     filter_mode = "global";
  };
};

  # Brave browser configuration with hardware acceleration
  programs.brave = {
    enable = true;
    commandLineArgs = [
      # Conservative hardware acceleration flags for Prime offload
      "--enable-gpu"
      "--enable-gpu-rasterization"
      "--enable-accelerated-video-decode"
      "--enable-accelerated-video-encode"
      "--enable-gpu-compositing"
      # VA-API flags
      "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder"
      "--use-gl=desktop"
      # Wayland flags
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
      "--enable-features=WaylandWindowDecorations"
      # Performance flags
      "--disable-background-timer-throttling"
      "--disable-backgrounding-occluded-windows"
      "--disable-renderer-backgrounding"
    ];
  };

  # Example keybinding (adjust to your window manager)
  # Example for sxhkd:
  # super + {equal,minus}
  #   ${nvidia_brightness_up}/bin/nvidia-brightness-up
  #   ${nvidia_brightness_down}/bin/nvidia-brightness-down
}
