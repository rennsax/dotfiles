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
    enable = mkEnableOption "npm xdg" // {
      default = config.myModules.xdg.enable;
    };
  };

  config = mkIf cfg.enable {
    # NPM weakly support XDG... Setting envs seems to work but for convenience I
    # still use the default per-user configuration file. Options are set
    # according to https://wiki.archlinux.org/title/XDG_Base_Directory.
    home.file.".npmrc".text = ''
      ; npm install -g
      prefix=${config.xdg.dataHome}/npm
      ; npm cache
      cache=${config.xdg.cacheHome}/npm
      ; npm init
      init-module=${config.xdg.configHome}/npm/config/npm-init.js
      ; logs
      logs-dir=${config.xdg.stateHome}/npm/logs
    '';
  };
}
