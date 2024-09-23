{
  pkgs,
  lib,
  myVars,
}:
{
  # Make symbolic link towards the flake with a path or string.
  # Caveat: this function returns a derivation that may import impurity!
  _mkRelSymLink =
    fileSubPathStr:
    let
      pathStr = myVars.nixConfigDir + "/" + fileSubPathStr;
    in
    pkgs.runCommandLocal "nix-config-${builtins.replaceStrings [ "/" ] [ "_" ] fileSubPathStr}-symlink"
      { }
      ''
        ln -s ${lib.escapeShellArg pathStr} $out
      '';
}
