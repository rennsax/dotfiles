{ lib, ... }:
{
  imports = [
    ./npm-xdg.nix
    ./go-xdg.nix
    ./history-littering.nix
  ];
  xdg.enable = lib.mkDefault true;
}
