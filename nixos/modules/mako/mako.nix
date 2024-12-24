{ config, pkgs, ... }: {
  programs.mako = {
    package = pkgs.mako;
    enable = true;
  };
}