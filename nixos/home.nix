{ config, lib, pkgs, inputs, ... }:

{
  imports = [ 
    # inputs.ags.homeManagerModules.default
    ./modules/waybar/waybar.nix
    ./modules/dunst/dunst.nix
  
   ];

  home.username = "parker";
  home.homeDirectory = "/home/parker";
  home.stateVersion = "24.05";
  home.packages = [];
  home.file = {};
  home.sessionVariables = {};

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = lib.mkForce "Zorin-Mint-Light";
    };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
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
}