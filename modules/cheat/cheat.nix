{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.myModules.cheat;
in
with lib;
{
  options.myModules.cheat = {
    enable = mkEnableOption "cheat";
    package = mkOption {
      type = types.package;
      default = pkgs.cheat;
      defaultText = literalExpression "pkgs.cheat";
      description = "The package to use for the cheat binary.";
    };
    enableZshIntegration = mkEnableOption "Zsh integration" // {
      default = true;
    };
    _personalCheatsheetsPath = mkOption {
      type = types.str;
      default = "";
      description = ''
        The absolute path of the personal cheatsheets.
        Caveat: enable this option imports impurity!
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [ cfg.package ];

      xdg.configFile."cheat/conf.yml" =
        let
          communityCheatsheets = pkgs.fetchFromGitHub {
            owner = "cheat";
            repo = "cheatsheets";
            rev = "36bdb99";
            sha256 = "sha256-Afv0rPlYTCsyWvYx8UObKs6Me8IOH5Cv5u4fO38J8ns=";
          };

        in
        {
          text = ''
            colorize: false
            style: monokai
            formatter: terminal256
            pager: ${pkgs.bat}/bin/bat -lbash -p
            cheatpaths:
              - name: community
                path: ${communityCheatsheets}
                tags: [ community ]
                readonly: true

              - name: personal
                path: ${cfg._personalCheatsheetsPath}
                tags: [ personal ]
                readonly: false
          '';
        };
    }

  ]);
}
