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

  varsFor,
}:
let
  system = "aarch64-darwin";
in
{
  darwin = nix-darwin.lib.darwinSystem {
    inherit system;
    modules = [
      nixpkgsOverlaysModule
      nixFlakeRegistryModule
      darwinModule

      ./darwin.nix
    ];
  };

  user501 = home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.${system};
    modules = [
      homeManagerModule

      ./home-501.nix
    ];

    extraSpecialArgs = {
      nur-rennsax-pkgs = nur-rennsax.packages.${system};
      myVars = varsFor system;
    };
  };
}
