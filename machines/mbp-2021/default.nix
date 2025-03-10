# My MacBook Pro, 14-inch, 2021
{
  nixpkgs,
  nix-darwin,
  home-manager,
  nur-rennsax,
  nixpkgsOverlaysModule,
  nixFlakeRegistryModule,
  darwinModule,
  homeManagerModule,

  myVars,
}:
let
  system = "aarch64-darwin";
in
{
  darwinConfigurations = nix-darwin.lib.darwinSystem {
    inherit system;
    modules = [
      nixpkgsOverlaysModule
      nixFlakeRegistryModule
      darwinModule

      ./darwin.nix
    ];
    specialArgs = {
      inherit myVars;
    };
  };

  homeConfigurations.user501 = home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.${system};
    modules = [
      nixpkgsOverlaysModule
      nixFlakeRegistryModule
      homeManagerModule

      ./home-501.nix
    ];

    extraSpecialArgs = {
      nur-rennsax-pkgs = nur-rennsax.packages.${system};
      inherit myVars;
    };
  };
}
