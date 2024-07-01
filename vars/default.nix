{ system }:
{
  me = import ./me.nix;
  network = import ./network.nix;
  # Parent directory of the whole Nix flake. Must be hard-coded.
  nixConfigDir = "$HOME/.dotfiles";

  inherit system;
  isDarwin = (builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ]);
  isLinux = (builtins.elem system [ "aarch64-linux" "x86_64-linux" ]);
}
