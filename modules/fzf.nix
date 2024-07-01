{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.myModules.fzf;
in
{
  options.myModules.fzf = {
    enable = mkEnableOption "fzf";
    package = mkPackageOption pkgs "fzf" { };
  };

  config = mkIf cfg.enable {
    programs.zsh.sessionVariables = {
      FZF_SCRIPT_BASE = "${cfg.package}/share/fzf";
    };
    home.packages = [ cfg.package ];
  };
}
