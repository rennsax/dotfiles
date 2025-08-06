# Per-machine declaration.
{
  nixpkgs,
  nix-darwin,
  home-manager,
  nur-rennsax,
  nix-vscode-extensions,
  nixos-wsl,
  ...
}@inputs:
let
  lib = nixpkgs.lib;

  nixpkgsOverlaysModule = {
    nixpkgs.overlays = import ../overlays {
      inherit nix-vscode-extensions;
    };
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
  myVars = import ../vars { inherit lib; };

  callMachine = nixpkgs.lib.callPackageWith {
    inherit
      nixpkgs
      nix-darwin
      home-manager
      nur-rennsax
      nixos-wsl
      ;
    inherit nixpkgsOverlaysModule nixFlakeRegistryModule;
    darwinModule = myModules.darwin;
    homeManagerModule = myModules.home;

    inherit myVars;
  };

  normalizeMachineOutputsFor =
    with lib;
    names: outputs:
    foldl' recursiveUpdate { } (
      flip mapAttrsToList outputs (
        machineName: configs:
        let
          validConfigs = filterAttrs (n: v: intersectLists [ n ] names != [ ]) configs;
          f =
            name: config:
            if name == "homeConfigurations" then
              concatMapAttrs (u: c: { "${name}"."${machineName}.${u}" = c; }) config
            else
              setAttrByPath [
                name
                machineName
              ] config;
        in
        concatMapAttrs f validConfigs
      )
    );

  validAttrNames = [
    "nixosConfigurations"
    "homeConfigurations"
    "darwinConfigurations"
  ];

  /**
    Normalize the outputs to flake-flavor format. The result attribute is
    preferred by tools like `nixos-rebuild`, `home-manager`. This allows me to
    group my configurations per-machine and keep using these convenient tools.

    # type

    ```
    normalizeMnormalizeMachineOutputs :: AttrSet -> AttrSet
    ```

    # Example
    ```nix
    normalizeMachineOutputs {
      machine1 = {
        nixosConfigurations = "foo";
        homeConfigurations.user1 = "bar";
      };
      machine2 = {
        darwinConfigurations = "baz";
      };
    }
    => {
      nixosConfigurations.machine1 = "foo";
      homeConfigurations."machine1.user1" = "bar";
      darwinConfigurations.machine2 = "baz";
    }
    ```
  */
  normalizeMachineOutputs = normalizeMachineOutputsFor validAttrNames;

in
normalizeMachineOutputs {
  "sequoia-workstation" = callMachine ./mbp-2021 { };
  "ipads-server" = callMachine ./lab-server { };
  "wsl-nixos" = callMachine ./wsl-nixos { };
  "ipads-nixos" = callMachine ./lab-workstation { };
}
