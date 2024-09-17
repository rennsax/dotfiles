# Extra configurations for development.
# Type: plugin.
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
  myModules =
    {
      git.signingConfig = true;
      emacs.enable = true;
    }
    // lib.optionalAttrs myVars.isDarwin {
      hammerspoon.enable = true;
      orbstack.enable = true;
    };

  programs.kitty.enable = isLinux;

  home.packages = with pkgs; [
    # Programming
    gh
    shellcheck
    nixfmt-rfc-style
  ];

  home.sessionVariables = {
    http_proxy = myVars.network.proxy.clash;
    https_proxy = myVars.network.proxy.clash;
  };

}
