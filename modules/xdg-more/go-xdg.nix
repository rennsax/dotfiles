{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.myModules.xdg.go;

in
{
  options.myModules.xdg.go = {
    enable = mkEnableOption "go xdg" // {
      default = config.myModules.xdg.enable;
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      GOPATH = "${config.xdg.dataHome}/go";
      GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
    };
  };
}
