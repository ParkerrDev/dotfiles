{
  description = "Nixos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:kamokuma5/nixpkgs/personal_mods";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    hyprland.url = "github:hyprwm/Hyprland";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-stable, nix-flatpak, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      pkgs_unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
      pkgs_stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
    in
    {
      nixosConfigurations.strixy = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit pkgs_unstable;
          inherit pkgs_stable;
        };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.default
          nix-flatpak.nixosModules.nix-flatpak
          {
            # Import the Windscribe module directly
            imports = [ ./modules/windscribe ];
            # Enable nixpkgs config
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };
    };
}
