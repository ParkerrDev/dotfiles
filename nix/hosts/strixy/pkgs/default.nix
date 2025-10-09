# /etc/nixos/pkgs/default.nix
{ pkgs, ... }: let
  callPackage = pkgs.callPackage;
in {
  nixpkgs.overlays = [(final: prev: {
    mypackages = {
      gtk-theme = callPackage ./theme/gtk-theme.nix {};
      mt7961 = callPackage ./drivers/mt7961.nix {};
    };
  })];
}
