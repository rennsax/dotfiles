{
  pkgs,
  lib,
  config,
  myVars,
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
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    xdg.configFile."starship.toml" = {
      source = pkgs.writeText "starship.toml" ''
        ${lib.readFile ./config/starship.toml}

        ## Platform-dependent settings

        ${lib.readFile (
          if myVars.isDarwin then ./config/starship-darwin.toml else ./config/starship-linux.toml
        )}
      '';
    };
  };
}
