{
  description = "Nixos flake";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-stable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
      stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
    in
    {
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
            imports = [ ./modules/windscribe ];
            # Enable nixpkgs config
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };
    };
}
