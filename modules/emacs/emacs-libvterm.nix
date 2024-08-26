{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.myModules.emacs-libvterm;
in
with lib;
{
  options.myModules.emacs-libvterm = {
    enableZshIntegration = mkEnableOption "emacs-libvterm integration with Zsh";
  };

  config = {
    # Make it a little late so it can be loaded after starship.
    programs.zsh.initExtra = mkIf cfg.enableZshIntegration (mkOrder 1200 ''
      source ${./shell/vterm.zsh}
    '');
  };

}
