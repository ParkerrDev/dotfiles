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
    nh # nix management utility
    nixpkgs-fmt
    nil # language server protocol
    # lxqt.lxqt-policykit  # Polkit authentication
    libimobiledevice # iPhone File Support
    gnome.gvfs # iPhone File Support2
    ifuse # iPhone File Support
    steam-run # Run dynamically linked executables
    #appimage-run # Run app images
    ntfsprogs # Used for NTFS with Gparted
    home-manager
    nixd
  ];

  # Hardware control tools
  hardwareControl = [
    piper
    libratbag
    g810-led
    ddcutil
    cudaPackages.cudatoolkit
    i2c-tools # required by ddcutil
    asusctl
    pulseaudio

    # TRYING TO fix HARDWARE ACCELERATION
    vulkan-tools
    vulkan-loader
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
    wdisplays
    networkmanagerapplet
    brightnessctl # very broken
    brillo # replaces brightnessctl for now
    # xorg.xrandr
    playerctl
    pamixer
    pavucontrol
    grim # screenshots
    slurp
    hyprshot
    wtype
    wl-clipboard
    pipewire
    ydotool
    tesseract
  ];

  # Look and feel
  lookAndFeel = [
    ags
    adw-gtk3
    libdbusmenu-gtk3
  ];

  # Personal applications
  personal = [
    zed-editor
    code-cursor-fhs
    kitty
    alacritty
    brave # chromium broken on wayland with hybrid GPU and HiDPI
    ladybird
    # inputs.zen-browser.packages."${system}".specific
    notesnook
    #vscode-fhs # changed from vscode to vscode-fhs
    # code-cursor
    #obs-studio
    qbittorrent
    alpaca
    #ytdownloader
    wireguard-tools # VPNs
    openvpn # VPNs
    motrix
    rpi-imager
    #easyeffects # Equalizer
    # zed-editor
    #github-desktop
    #gimp
    #betterdiscord-installer
    telegram-desktop
    discord-ptb
    discord
    #cmatrix
    deskflow
  ];

  # Hacking tools
  hacking = [
    aircrack-ng
    (pkgs.runCommand "hashcat-with-full-cuda" { buildInputs = [ pkgs.makeWrapper ]; } ''
  mkdir -p $out/bin

  LIBS="${pkgs.lib.makeLibraryPath [
    pkgs.cudaPackages_12_8.cudatoolkit
    pkgs.cudaPackages_12_8.cuda_cudart
    pkgs.cudaPackages_12_8.cuda_nvrtc
    pkgs.cudaPackages_12_8.cuda_nvcc
    pkgs.cudaPackages_12_8.libcublas
    pkgs.cudaPackages_12_8.libcufft
    pkgs.cudaPackages_12_8.libcurand
    pkgs.cudaPackages_12_8.libcusolver
    pkgs.cudaPackages_12_8.libcusparse
    pkgs.cudaPackages_12_8.cuda_cupti
  ]}"

  # Add driver libraries first to ensure libcuda.so is found
  makeWrapper ${pkgs.hashcat}/bin/hashcat $out/bin/hashcat \
    --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib:$LIBS"
'')

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
    #lutris
    protontricks
    gamemode
    gamescope
  ];

  # Command line tools
  commandLine = [
    helix
    blesh # ble.sh
    #atuin
    #neovim
    #neofetch
    fastfetch
    git
    usbutils # lsusb
    feh
    lf # cli file manager
    fzf
    tree
    tldr
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
    zellij
    oterm # ollama tui
    discordo # discord cli
    ngrok # for cursor with ollama
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
    # (ollama.override { acceleration = "cuda"; })
    ollama-cuda
    nodejs_22 # npm for electron apps
    pnpm
    wireplumber # not sure what it is used for
    devenv
    cargo
    rustc
    rustfmt
    clippy
    rust-analyzer
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
