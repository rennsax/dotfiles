{ lib, ... }:
{
  imports = [
    ./npm-xdg.nix
    ./go-xdg.nix
    ./history-littering.nix
  ];

  options.myModules.xdg = {
    enable = lib.mkEnableOption "more xdg configurations" // {
      default = true;
    };
  };
  config = {
    xdg.enable = lib.mkDefault true;
  };
}
