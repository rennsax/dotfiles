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

      # Workaround found at https://github.com/nix-community/home-manager/issues/3075#issuecomment-1593969080.
      systemAttrs =
        systems: prefix: f:
        with lib;
        listToAttrs (flip builtins.map systems (system: nameValuePair "${prefix}-${system}" (f system)));

      defaultSystemAttrs = systemAttrs flake-utils.lib.defaultSystems;

      /**
        Generate an attribute list for homeConfigurations:
        { "${name}-x86_64-linux": ..., "${name}-aarch64-darwin": ..., ... }
      */
      combinedHome =
        name: modules:
        defaultSystemAttrs name (
          system:
          home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = lib.unique (
              modules
              ++ [
                myModules.home
                myOverlays
              ]
            );
            extraSpecialArgs = specialArgsFor system // {
              homeVariant = name;
            };
          }
        );
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
    // {
      homeConfigurations =
        combinedHome "worker" [
          ./config/home/general.nix
          ./config/home/base.nix
          ./config/home/nix-scripts.nix
          ./config/home/develop.nix
        ]
        // combinedHome "minimal" [
          ./config/home/general.nix
          ./config/home/mini.nix
        ]
        // combinedHome "typical" [
          ./config/home/general.nix
          ./config/home/base.nix
          ./config/home/nix-scripts.nix
        ];
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
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
