pkgs: with pkgs;[
  #Custom
  mypackages.gtk-theme
  mypackages.mt7961 # must disable gigabyte ethernet to work

  # Nix OS
  # home-manager
  #nixfmt-classic # Nix formatter
  nixpkgs-fmt
  nil # language server protocol
  lxqt.lxqt-policykit # Polkit authentication
  libimobiledevice # iPhone File Support
  gnome.gvfs # iPhone File Support2
  ifuse # iPhone File Support
  steam-run # Run dynamically linked executables
  appimage-run # Run app immages
  #hfsprogs # Used for HFS with Gparted
  ntfsprogs # Used for NTSG with Gparted

  # Hardware Control
  # asusctl
  # supergfxctl
  piper
  libratbag
  g810-led
  ddcutil
  i2c-tools # required by ddcutil

  # Hyprland
  wofi
  waybar
  # wlogout # defined in home manager
  gammastep
  swaylock-effects
  swaybg
  wdisplays
  networkmanagerapplet
  # brightnessctl
  playerctl
  pamixer
  #dunst
  mako
  pavucontrol
  grim # screenshots
  slurp
  hyprshot
  wtype
  wl-clipboard
  pipewire

  ydotool

  # Look and Feel
  ags
  #libnotify # required by ags
  adw-gtk3
  libdbusmenu-gtk3

  # Personal
  kitty
  brave
  notesnook
  vscode
  obs-studio
  qbittorrent
  ytdownloader
  wireguard-tools #VPNs
  openvpn # VPNs
  motrix
  rpi-imager
  easyeffects # Equalizer
  zed-editor
  #thunderbird
  #protonvpn-gui
  #session-desktop # private messenger (not working)
  #briar-desktop # offline p2p e2ee tor messenger (not working)
  github-desktop
  gimp
  #freecad-wayland
  #figma-linux #kinda broken
  bambu-studio #broken on unstable as of 2025-12-28
  #dolphin-emu

  # Hacking
  aircrack-ng
  hashcat
  hashcat-utils
  wireshark
  hcxtools
  macchanger
  reaverwps-t6x
  crunch
  # cewl

  # Gaming
  protonup-qt
  mangohud
  lutris
  protontricks
  #heroic
  gamemode
  gamescope

  # Unreal Engine
  #mono
  #clang
  #SDL2_image
  #SDL2_mixer
  #SDL2_ttf

  #Unreal Projects
  #nodejs

  # Command Line Tools
  blesh # ble.sh
  atuin
  neovim
  neofetch
  fastfetch
  git
  usbutils # lsusb
  feh
  lf # cli file manager
  tree
  proxychains
  imagemagick
  ffmpeg # video utility required by imagemagick 
  # calibre
  unzip
  ipatool
  dpkg
  patchelf
  conky #system usage monitor

  # Graphical Utilities
  nautilus
  baobab
  gparted
  vlc
  realvnc-vnc-viewer

  # rust ebook project
  # cargo
  # rustup
  # rustc

  #NeuraLink Compression Challenge
  flac

  #Coding
  gh # github cli
  SDL2
  gcc
  gnumake
  cmake
  xorg.xhost # manage xhost perms
  (ollama.override { acceleration = "cuda"; })
  # nodejs_22 # npm for electron apps
  wireplumber # not sure what i used this for



  #ntfs3g # trying to mount ntfs drives and polkit
]
