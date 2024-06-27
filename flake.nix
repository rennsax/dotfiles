{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      darwinReleaseName = "sonoma";
      system = "aarch64-darwin";

      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;

      myVars = import ./vars { inherit pkgs; };
      myLib = import ./lib { inherit pkgs lib myVars; };
      myModules = import ./modules { };
    in
    {
      # Build darwin flake using:
      darwinConfigurations = {
        ${darwinReleaseName} = nix-darwin.lib.darwinSystem {
          modules = [
            myModules.darwin
            ./config/darwin.nix
          ];
          specialArgs = {
            inherit inputs myVars myLib;
          };
        };
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.${darwinReleaseName}.pkgs;

      homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          myModules.home.base
          myModules.home.darwin
          ./config/home.nix
        ];
        extraSpecialArgs = {
          inherit inputs myVars myLib;
        };
      };

      devShells.${system}.default = with pkgs; mkShell.override { inherit (llvmPackages_18) stdenv; } { };

    };
}
