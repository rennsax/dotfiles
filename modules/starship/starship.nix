{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.myModules.starship;
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

in
with lib;
{
  options = {
    myModules.starship.enable = lib.mkEnableOption "starship";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.starship = with lib; {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };

      xdg.configFile."starship.toml".text = readFile ./config/starship.toml;
    }

    {
      xdg.configFile."starship.toml".text = mkIf isDarwin (
        mkAfter (readFile ./config/starship-darwin.toml)
      );
    }

    {
      xdg.configFile."starship.toml".text = mkIf isLinux (
        mkAfter (readFile ./config/starship-linux.toml)
      );
    }

  ]);
}
