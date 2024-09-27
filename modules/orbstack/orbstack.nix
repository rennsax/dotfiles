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

  # Modify PATH and provides completion functions for docker/kubectl.
  # Must be sourced before compinit.
  shellInitFor = shell: ''
    source ~/.orbstack/shell/init.${shell}
  '';
in
{
  options.myModules.orbstack = {
    enable = mkEnableOption "orbstack";
    enableZshIntegration = mkEnableOption "Zsh integration" // {
      default = true;
    };
    # NOTE: Orbstack is installed by Homebrew.
  };

  config = mkIf cfg.enable {
    # Put this before my personal configuration, so the orb.plugin.zsh can be correctly loaded.
    programs.zsh = mkIf cfg.enableZshIntegration {
      initExtraBeforeCompInit = shellInitFor "zsh";
      # Setup orb/orbctl completion. Must be after compinit.
      initExtra = ''
        # From https://raw.githubusercontent.com/orbstack/orbstack/main/orb.plugin.zsh
        # make sure you execute this *after* asdf or other version managers are loaded
        eval "$(orbctl completion zsh)"
        compdef _orb orbctl
        compdef _orb orb
      '';
    };
  };

}
