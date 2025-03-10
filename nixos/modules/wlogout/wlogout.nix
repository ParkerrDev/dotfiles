{ config, pkgs, ... }: {

  home.file.".config/wlogout/assets" = {
    source = ./assets;
    recursive = true;
  };

  programs.wlogout = {
    enable = true;
    style = builtins.readFile ./wlogout.css;
  };
}
