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
    # It must have order > 1000 so it can be loaded after starship.
    programs.zsh.initContent = mkIf cfg.enableZshIntegration (mkOrder 1100 ''
      source ${./shell/vterm.zsh}
    '');
  };

}
