{ pkgs }:
{
  me = import ./me.nix;
  network = import ./network.nix;
  # Parent directory of the whole Nix flake. Must be hard-coded.
  nixConfigDir = "$HOME/.dotfiles";

  inherit (pkgs.stdenv.hostPlatform) isDarwin;
}
