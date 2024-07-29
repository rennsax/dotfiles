# Npm poorly support XDG standard. See https://github.com/npm/npm/issues/6675.
{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.myModules.xdg.npm;

in
{
  options.myModules.xdg.npm = {
    enable = mkEnableOption "npm xdg";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    };

    # https://wiki.archlinux.org/title/XDG_Base_Directory
    xdg.configFile."npm/npmrc".text = ''
      prefix=${config.xdg.dataHome}/npm
      cache=${config.xdg.cacheHome}/npm
      init-module=${config.xdg.configHome}/npm/config/npm-init.js
      logs-dir=${config.xdg.stateHome}/npm/logs
    '';
  };
}
