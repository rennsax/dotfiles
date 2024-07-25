# After opening Orbstack.app for the first time, it pollutes the system by:
#
#     1. Create symbolic links under /usr/local/bin
#     2. Create ~/.orbstack and ~/.docker, if they do not exit.
#     3. Create $ZDOTDIR/.zprofile and add scripts to initialize zsh completion.
#
# You can revert these changes if you don't like them.
#
# Since it's so impure, I do not include the orbstack package here. You should
# manually install it.
{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.myModules.orbstack;

  # Orbstack only provides completion for zsh.
  shellInitFor = shell: ''
    source ~/.orbstack/shell/init.${shell} 2>/dev/null || :
  '';
in
{
  options.myModules.orbstack = {
    enable = mkEnableOption "orbstack";
    enableZshIntegration = mkEnableOption "Zsh integration" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    # Put this before my personal configuration, so the orb.plugin.zsh can be correctly loaded.
    programs.zsh.initExtraBeforeCompInit = mkIf cfg.enableZshIntegration (shellInitFor "zsh");
  };

}
