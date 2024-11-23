{
  description = "Nixos flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      unstable = import nixpkgs { inherit system; config.allowUnfree = true; };
      stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
    in {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit unstable;
          inherit stable;
        };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.default
          {
            # Import the Windscribe module directly
            # imports = [ ./modules/windscribe ];
            # Enable nixpkgs config
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };
    };
}
