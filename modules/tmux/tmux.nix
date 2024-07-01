{
  pkgs,
  lib,
  config,
  myLib,
  ...
}:
with lib;
let
  cfg = config.myModules.tmux;
in
{
  options.myModules.tmux = {
    enable = mkEnableOption "tmux";
    package = mkPackageOption pkgs "zsh" { };

  };

  config = mkIf cfg.enable {
    programs.tmux.enable = mkForce false;
    home.packages = [ pkgs.tmux ];
    xdg.configFile = foldl' (a: b: a // b) { } (
      map (filename: { "tmux/${filename}".source = ./config/${filename}; }) (
        builtins.attrNames (builtins.readDir ./config)
      )
    );
  };
}
