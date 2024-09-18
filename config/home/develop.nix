# Extra configurations for development.
# Type: plugin.
{
  lib,
  pkgs,
  myVars,
  ...
}:
let
  inherit (myVars) isLinux isDarwin;
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

    gnupg
  ];

  # TODO: generalize, make a new option for home.activation
  # https://github.com/GPGTools/pinentry/blob/b7195e9d4c098ea315e18ade3b4dab210492fadf/macosx/PinentryMac.m#L75
  home.activation.darwinSetup = lib.mkIf isDarwin (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      __PATH_BEFORE="$PATH"
      export PATH="/usr/bin:/bin"
      defaults write org.gpgtools.pinentry-mac DisableKeychain -bool yes
      export PATH="$__PATH_BEFORE"
    ''
  );

  home.sessionVariables = {
    http_proxy = myVars.network.proxy.clash;
    https_proxy = myVars.network.proxy.clash;
  };

}
