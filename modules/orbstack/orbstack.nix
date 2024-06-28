{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.myModules.cheat;
in
{
  options.myModules.orbstack = {
    enable = mkEnableOption "orbstack";
    enableZshIntegration = mkEnableOption "Zsh integration" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.zsh.initExtraBeforeCompInit = ''
      # Added by OrbStack: command-line tools and integration
      source ~/.orbstack/shell/init.zsh 2>/dev/null || :
    '';
  };

}
