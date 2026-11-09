{
  nixpkgs,
  home-manager,
  nixpkgsOverlaysModule,
  nixFlakeRegistryModule,
  homeManagerModule,
  myVars,
}:
let
in
{
  nixosConfigurations = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      nixpkgsOverlaysModule
      nixFlakeRegistryModule
      home-manager.nixosModules.home-manager
      ./nixos-config.nix
    ];
    specialArgs = {
      inherit myVars homeManagerModule;
    };
  };
}
