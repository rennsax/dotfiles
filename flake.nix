{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    emacs-lsp-booster = {
      url = "github:slotThe/emacs-lsp-booster-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      flake-utils,
      emacs-lsp-booster,
      ...
    }:
    let
      lib = nixpkgs.lib;

      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      varsFor = system: import ./vars { inherit system; };
      libFor = system: import ./lib {
        pkgs = nixpkgs.legacyPackages.${system};
        myVars = varsFor system;
        inherit lib;
      };

      myModules = import ./modules { };

      myOverlays = {
        nixpkgs.overlays = [
          emacs-lsp-booster.overlays.default
        ];
      };
    in
    {
      # Build darwin flake using:
      darwinConfigurations = {
        "sonoma" = nix-darwin.lib.darwinSystem {
          modules = [
            myModules.darwin
            ./config/darwin.nix
          ];
          specialArgs = {
            inherit inputs;
            myLib = libFor "aarch64-darwin";
            myVars = varsFor "aarch64-darwin";
          };
        };
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."sonoma".pkgs;

      homeConfigurations = forAllSystems (
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            myModules.home
            myOverlays
            ./config/home.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
            myVars = varsFor system;
            myLib = libFor system;
          };
        }
      );

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
    );
}
