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
    system = "x86_64-linux";
    modules = [
      nixpkgsOverlaysModule
      nixFlakeRegistryModule
      home-manager.nixosModules.home-manager
      ./nixos-config.nix
    ];
    specialArgs = {
      # homeManagerModule needs to be passed to `home-manager.users.<name>`.
      inherit homeManagerModule home-manager myVars;
    };
  };
}
