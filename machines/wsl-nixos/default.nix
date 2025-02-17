{
  nixos-wsl,
  home-manager,
  nixpkgs,
  homeManagerModule,
  myVars,
}:
{
  nixosConfigurations = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos-wsl.nixosModules.wsl
      home-manager.nixosModules.home-manager

      (import ./nixos-config.nix)
    ];
    specialArgs = {
      inherit homeManagerModule myVars;
    };
  };
}
