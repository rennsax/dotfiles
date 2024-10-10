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
      darwinSetup.scripts = ''
        # https://github.com/GPGTools/pinentry/blob/b7195e9d4c098ea315e18ade3b4dab210492fadf/macosx/PinentryMac.m#L75
        run /usr/bin/defaults write org.gpgtools.pinentry-mac DisableKeychain -bool yes
      '';
    }
    // lib.optionalAttrs myVars.isDarwin {
      hammerspoon.enable = true;
      # NOTE: install Orbstack manually with DMG image.
      orbstack.enable = true;
    };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.kitty.enable = isLinux;

  home.packages = with pkgs; [
    # Programming
    shellcheck
    nixfmt-rfc-style

    gnupg
  ];


  home.sessionVariables = {
    http_proxy = myVars.network.proxy.clash;
    https_proxy = myVars.network.proxy.clash;
  };

}
