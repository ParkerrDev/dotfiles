{ config, pkgs, ... }: {

  home.file.".config/wofi/style.css" = {
    source = ./style.css; # Relative to this nix file
  };
}
