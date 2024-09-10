pkgs: with pkgs;[
  #Custom
  mypackages.gtk-theme
  mypackages.mt7961

  # Nix OS
  #home-manager
  nixfmt-classic # Nix formatter
  nil # language server protocol
  lxqt.lxqt-policykit # Polkit authentication
  libimobiledevice # iPhone File Support
  gnome.gvfs # iPhone File Support2
  ifuse # iPhone File Support
  steam-run # Run dynamically linked executables
  appimage-run # Run app immages
  #hfsprogs # Used for HFS with Gparted
  ntfsprogs # Used for NTSG with Gparted

  # Asus ROG Strix (Patches) (keeping out of superstition that it increases performance)
  sof-firmware # trying to fix sound
  jack2 # trying to fix sound
  linuxKernel.packages.linux_xanmod_latest.nct6687d
  linuxKernel.packages.linux_xanmod_latest.asus-ec-sensors
  # linuxKernel.packages.linux_6_9.asus-ec-sensors
  linuxKernel.packages.linux_lqx.asus-ec-sensors
  linuxKernel.packages.linux_zen.asus-ec-sensors
  asusctl
  alsa-utils # cli sound and audio utils

  # Vitualization

  # VBoxManage internalcommands createrawvmdk -filename /home/parker/VBOX/Win11VirtualXtraDisk.vmdk -rawdisk /dev/nvme1n1 -partitions 1

  #virtualbox
  # qemu
  # OVMF

  # Hyprland
  wofi
  waybar
  wlogout
  gammastep
  swaylock-effects
  swaybg
  wdisplays
  networkmanagerapplet
  brightnessctl
  playerctl
  pamixer
  dunst
  pavucontrol
  grim # screenshots
  slurp
  wtype
  wl-clipboard
  pipewire

  ydotool

  # Look and Feel
  ags
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
  motrix
  blender
  rpi-imager
  easyeffects # Equalizer
  #krita
  zed-editor
  session-desktop
  github-desktop
  gimp

  # Gaming
  protonup-qt
  mangohud
  lutris
  protontricks
  heroic
  gamemode

  # Unreal Engine
  #mono
  #clang
  #SDL2_image
  #SDL2_mixer
  #SDL2_ttf

  #Unreal Projects
  #nodejs

  # Hardware Control
  asusctl
  supergfxctl
  piper
  libratbag
  g810-led
  ddcutil
  i2c-tools # required by ddcutil

  # Command Line Tools
  blesh # ble.sh
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
  calibre
  unzip

  # Graphical Utilities
  nautilus
  baobab
  gparted
  vlc

  #Coding
  gh # github cli
  SDL2
  gcc
  gnumake
  cmake
  rustup
  rustc
  cargo
  xorg.xhost # manage xhost perms
  (ollama.override { acceleration = "cuda"; })

  wireplumber # not sure what i used this for
]
