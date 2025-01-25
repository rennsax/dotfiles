{
  nixos-wsl,
  nixpkgs,
}
:
let
  config = {
    wsl.enable = true;
    wsl.defaultUser = "nixos";

    nix.settings = {
      experimental-features = "nix-command flakes";
      substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      ];
    };

    system.stateVersion = "24.05";
  };
in
{
  nixosConfigurations = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      nixos-wsl.nixosModules.wsl
      config
    ];
  };
}
