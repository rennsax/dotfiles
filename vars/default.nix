{ lib, ... }:
with lib;
let
  getEnvNonEmpty =
    env:
    let
      v = builtins.getEnv env;
    in
    assert assertMsg (v != "") ''
      ${env} is unset!
      Make sure you set this environment variable and evaluate in impure mode.
    '';
    v;
in
{
  me = {
    username = getEnvNonEmpty "USER";
    userFullName = "Bojun Ren";
    userNickname = "Rennsax";
    userEmail = "me.rennsax@gmail.com";
  };
  # Parent directory of the whole Nix flake. Must be hard-coded.
  nixConfigDir = getEnvNonEmpty "NIX_CONFIG_DIR";
}
