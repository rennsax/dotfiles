# Per-machine declaration.
{
  nixpkgs,
  nix-darwin,
  home-manager,
  nur-rennsax,
  ...
}@inputs:
let
  nixpkgsOverlaysModule = {
    nixpkgs.overlays = import ../overlays { };
  };

  # https://github.com/NixOS/nix/issues/7026
  nixFlakeRegistryModule = {
    nix.registry = {
      nixpkgs.flake = inputs.nixpkgs;
      flake-utils.flake = inputs.flake-utils;
      nix-darwin.flake = inputs.nix-darwin;
    };
  };

  myModules = import ../modules { };
  varsFor = system: import ../vars { inherit system; };

  callMachine = nixpkgs.lib.callPackageWith {
    inherit nixpkgs nix-darwin home-manager nur-rennsax;
    inherit nixpkgsOverlaysModule nixFlakeRegistryModule;
    darwinModule = myModules.darwin;
    homeManagerModule = myModules.home;

    # FIXME
    inherit varsFor;
  };

in
{
  machines = {
    # "sonoma-workstation" = import ./mbp-2021 {
    #   inherit makeDarwin;
    # };
    "sonoma-workstation" = callMachine ./mbp-2021 { };
  };
}
