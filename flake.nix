{
  description = "Rennsax's Nix configuration, for Unix systems like macOS and GNU/Linux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      flake-utils,
      ...
    }:
    let
      lib = nixpkgs.lib;

      varsFor = system: import ./vars { inherit system; };
      libFor =
        system:
        import ./lib {
          pkgs = nixpkgs.legacyPackages.${system};
          myVars = varsFor system;
          inherit lib;
        };

      myModules = import ./modules { };

      myOverlays = {
        nixpkgs.overlays = import ./overlays { };
      };

      specialArgsFor = system: {
        inherit inputs;
        myLib = libFor system;
        myVars = varsFor system;
      };
    in
    {
      darwinConfigurations = {
        "sonoma" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            myModules.darwin
            myOverlays
            ./config/darwin.nix
          ];
          specialArgs = specialArgsFor "aarch64-darwin";
        };
      };

      nixosConfigurations = {
        "nixos" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            myOverlays
            ./config/nixos.nix
          ];
          specialArgs = specialArgsFor "x86_64-linux";
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        specialArgs = specialArgsFor system;
      in
      {
        homeConfigurations = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            myModules.home
            myOverlays
            ./config/home.nix
          ];
          extraSpecialArgs = specialArgs;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nil
            nixfmt-rfc-style
          ];
        };
      }
    )
    // {
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."sonoma".pkgs;
      nixosPackages = self.nixosConfigurations."nixos".pkgs;
    };
}
