{
  pkgs,
  lib,
  myVars,
}:
{
  # A simple wrapper for mkDerivation to combine multiple files into one directory.
  mkCombinedDir =
    args@{ name, files }:
    pkgs.stdenvNoCC.mkDerivation (
      let
        srcs = map (file: file.src) files;
        pairs = map (file: {
          from = file.src;
          to = file.name;
        }) files;
      in
      rec {
        inherit name;
        phases = [
          # "unpackPhase"
          "buildPhase"
        ];
        # unpackPhase = ''
        #   for _src in $srcs; do
        #     cp "$_src" $(stripHash "$_src")
        #   done
        # '';
        buildPhase = lib.concatStringsSep "\n" (
          [ "mkdir -p $out" ] ++ (map ({ from, to }: "cp ${from} $out/${to}") pairs)
        );
      }
    );

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
