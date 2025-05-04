{ config, pkgs, ... }: {

  services.mako = {
    package = pkgs.mako;
    enable = true;
    extraConfig = builtins.readFile ./config;
  };
}