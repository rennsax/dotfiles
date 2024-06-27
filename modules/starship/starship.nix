{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.myModules.starship;
in
{
  options = {
    myModules.starship.enable = lib.mkEnableOption "starship";
  };

  config = lib.mkIf cfg.enable {

    programs.starship = with lib; {
      enable = true;
      enableZshIntegration = mkForce false;
      enableBashIntegration = mkForce false;
    };

    xdg.configFile."starship.toml" = {
      source = ./starship.toml;
    };
  };
}
