{
  nixos-wsl,
  nixpkgs,
}:
{
  nixosConfigurations = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos-wsl.nixosModules.wsl
      (import ./nixos-config.nix)
    ];
  };
}
