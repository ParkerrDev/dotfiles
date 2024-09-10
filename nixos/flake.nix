{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # stylix.url = "github:danth/stylix";
    # nix-flatpak.url = "github:gmodena/nix-flatpak";

    # ags.url = "github:Aylur/ags";

    home-manager = {
      # url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        # nix-flatpak.nixosModules.nix-flatpak
        ./configuration.nix
        # inputs.stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
