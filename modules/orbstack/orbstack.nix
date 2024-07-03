{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.myModules.orbstack;
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
    programs.zsh.initExtraBeforeCompInit = (mkOrder 200 ''
      # Added by OrbStack: command-line tools and integration
      source ~/.orbstack/shell/init.zsh 2>/dev/null || :
    '');
  };

}
