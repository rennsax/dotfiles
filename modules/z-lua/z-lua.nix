{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.myModules.z-lua;

in
{
  options.myModules.z-lua = {
    enable = mkEnableOption "z-lua";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      _ZL_DATA = "${config.xdg.stateHome}/zlua-data";
    };
    programs.z-lua = {
      enable = true;
      options = [
        "once"
        "enhanced"
        "fzf"
      ];
    };
  };
}
