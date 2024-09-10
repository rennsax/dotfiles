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
    emacs -nw "$@"
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
    home.sessionVariables = rec {
      EDITOR = "\${EDITOR:-${editorWrapper}}";
      # See "(web2c) Editor invocation".
      TEXEDIT = "${EDITOR} +%d %s";
    };
  };

}
