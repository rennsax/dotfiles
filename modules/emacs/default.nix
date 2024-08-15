{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.myModules.emacs;
in
with lib;
{
  imports = [ ./emacs-deps.nix ];

  options.myModules.emacs = {
    enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      # TODO: enable Emacs to startup at "simple" mode.
      EDITOR = "\${EDITOR:-emacs -Q -nw}";
    };
  };

}
