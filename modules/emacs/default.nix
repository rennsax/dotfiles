{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.myModules.emacs;
  # Use a editor wrapper script, instead of simple "emacs -Q -nw", so some
  # programs like crontab(1) can find the file.
  editorWrapper = pkgs.writeShellScript "editor-wrapper" ''
    emacs -Q -nw "$@"
  '';
in
with lib;
{
  imports = [
    ./emacs-deps.nix
    ./emacs-libvterm.nix
  ];

  options.myModules.emacs = {
    enable = mkEnableOption "emacs";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      # TODO: enable Emacs to startup at "simple" mode.
      EDITOR = "\${EDITOR:-${editorWrapper}}";
    };
  };

}
