{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.myModules.tmux;
in
{
  options.myModules.tmux = {
    enable = mkEnableOption "tmux";
    package = mkPackageOption pkgs "tmux" { };
    oh-my-tmux.enable = mkEnableOption "oh-my-tmux" // {
      default = false;
      description = ''
        Whether to install my tmux configurations based on gpakosz/.tmux.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.tmux.enable = mkForce false;
      home.packages = [ cfg.package ];
    }
    (mkIf cfg.oh-my-tmux.enable {
      # REVIEW: If plugin system is enabled, this tmux configuration will try to
      # create directory in the Nix store, which will cause failure. Another
      # solution is setting env TMUX_PLUGIN_MANAGER_PATH to a modifiable path.
      xdg.configFile."tmux".source = pkgs.callPackage ./tmux-conf.nix { disablePlugin = true; };
    })
  ]);
}
