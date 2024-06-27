{ ... }:
{
  me = import ./me.nix;
  # Parent directory of the whole Nix flake. Must be hard-coded.
  nixConfigDir = "$HOME/.dotfiles";
}
