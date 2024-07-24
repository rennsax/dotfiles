{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.myModules.z-lua;

  aliases = {
    zc = "z -c"; # restrict matches to subdirs of $PWD
    zb = "z -b"; # quickly cd to the parent directory
    zi = "z -I"; # use fzf
  };

in
{
  options.myModules.z-lua = {
    enable = mkEnableOption "z-lua";
    enableAliases = mkEnableOption "z-lua shell aliases";
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
      enableAliases = mkForce false;
    };

    programs.zsh.shellAliases = mkIf cfg.enableAliases aliases;
  };
}
