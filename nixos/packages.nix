{ pkgs }:
with pkgs;
let
  # Use pkgs.rog-control-center instead of rog-control-center directly
  # rogControlCenter = pkgs.rog-control-center or null;

  # Custom packages
  customPackages = [
    (mypackages.gtk-theme or null)
    (mypackages.mt7961 or null) # must disable gigabyte ethernet to work
  ];

  # NixOS-specific packages
  nixosPackages = [
    nixpkgs-fmt
    nil # language server protocol
    # lxqt.lxqt-policykit  # Polkit authentication
    libimobiledevice # iPhone File Support
    gnome.gvfs # iPhone File Support2
    ifuse # iPhone File Support
    steam-run # Run dynamically linked executables
    appimage-run # Run app images
    ntfsprogs # Used for NTFS with Gparted
    home-manager
  ];

  # Hardware control tools
  hardwareControl = [
    piper
    libratbag
    g810-led
    ddcutil
    i2c-tools # required by ddcutil
    cudaPackages.cudatoolkit
    asusctl
  ];

  # Hyprland-related packages
  hyprland = [
    hyprpolkitagent
    hyprcursor
    hyprpaper
    hyprpicker
    hypridle
    hyprlock
    hyprsunset
    hyprlang
    aquamarine
    wofi
    waybar
    # gammastep
    # swaylock-effects
    # swaybg
    wdisplays
    networkmanagerapplet
    brightnessctl # very broken
    brillo # replaces brightnessctl for now
    # xorg.xrandr
    playerctl
    pamixer
    mako
    pavucontrol
    grim # screenshots
    slurp
    hyprshot
    wtype
    wl-clipboard
    pipewire
    ydotool
  ];

  # Look and feel
  lookAndFeel = [
    ags
    adw-gtk3
    libdbusmenu-gtk3
  ];

  # Personal applications
  personal = [
    kitty
    brave #chromium broken on wayland with hybrid GPU and HiDPI
    ladybird
    # inputs.zen-browser.packages."${system}".specific
    notesnook
    vscode-fhs # changed from vscode to vscode-fhs
    # code-cursor
    obs-studio
    qbittorrent
    ytdownloader
    wireguard-tools # VPNs
    openvpn # VPNs
    motrix
    rpi-imager
    easyeffects # Equalizer
    # zed-editor
    github-desktop
    gimp
    # betterdiscord-installer
    telegram-desktop
    discord-ptb
    cmatrix
  ];

  # Hacking tools
  hacking = [
    aircrack-ng
    (hashcat.overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [ autoAddDriverRunpath ];
    }))
    hashcat-utils
    wireshark
    hcxtools
    macchanger
    reaverwps-t6x
    crunch
  ];

  # Gaming tools
  gaming = [
    protonup-qt
    mangohud
    lutris
    protontricks
    gamemode
    gamescope
  ];

  # Command line tools
  commandLine = [
    blesh # ble.sh
    atuin
    neovim
    neofetch
    fastfetch
    git
    nh # nix management utility
    usbutils # lsusb
    feh
    lf # cli file manager
    fzf
    tree
    proxychains
    imagemagick
    ffmpeg # required by imagemagick 
    unzip
    ipatool
    dpkg
    patchelf
    discordchatexporter-cli
    btop
    libva-utils
    pciutils
    fabric-ai # fabric-cli (ai tool)
    lynx # text browser
    thefuck # command line tool to correct mistakes
  ];

  # Graphical utilities
  graphicalUtilities = [
    nautilus
    baobab
    gparted
    vlc
    realvnc-vnc-viewer
  ];

  # Coding and development packages
  coding = [
    gh # GitHub CLI
    SDL2
    gcc
    llvm
    gnumake
    cmake
    xorg.xhost # manage xhost perms
    (ollama.override { acceleration = "cuda"; })
    nodejs_22 # npm for electron apps
    pnpm
    wireplumber # not sure what it is used for
    devenv
    conda
  ];

  # Combine all groups including the optional rogControlCenter
  allPackages = [
    # (if rogControlCenter != null then rogControlCenter else null)
  ]
  ++ customPackages
  ++ nixosPackages
  ++ hardwareControl
  ++ hyprland
  ++ lookAndFeel
  ++ personal
  ++ hacking
  ++ gaming
  ++ commandLine
  ++ graphicalUtilities
  ++ coding;
in
lib.filter (pkg: pkg != null) allPackages
