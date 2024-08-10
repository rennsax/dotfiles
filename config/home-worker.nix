{
  lib,
  pkgs,
  myVars,
  ...
}:
let
  inherit (myVars) isLinux;
in
{
  myModules = {
    emacs.enable = true;
  };

  programs.kitty.enable = isLinux;
}
