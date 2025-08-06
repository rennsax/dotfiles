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
  me = rec {
    username = getEnvNonEmpty "USER";
    userFullName = "Bojun Ren";
    userNickname = "Rennsax";
    userEmail = "me.rennsax@gmail.com";
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzlb7/RuaRMcNRaRBQ8L4l2v81DOGadNinPlq7VT7XM ${userFullName} <${userEmail}>";
  };
  # Parent directory of the whole Nix flake. Must be hard-coded.
  nixConfigDir = getEnvNonEmpty "NIX_CONFIG_DIR";
}
