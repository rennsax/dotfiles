{
  pkgs,
  lib,
  config,
  myVars,
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
    _enableEditableCheatsheets = mkEnableOption ''
      Whether the user cheatsheets is editable.
      Caveat: enable this option imports impurity!
    '';
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

          personalCheatsheets = (
            if cfg._enableEditableCheatsheets then
              "${myVars.nixConfigDir}/modules/cheat/cheatsheets/personal"
            else
              "${config.xdg.configHome}/cheat/cheatsheets/personal"
          );

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
                path: ${personalCheatsheets}
                tags: [ personal ]
                readonly: ${if cfg._enableEditableCheatsheets then "false" else "true"}
          '';
        };
    }

    (mkIf (!cfg._enableEditableCheatsheets) {
      xdg.configFile."cheat/cheatsheets/personal" = {
        source = ./cheatsheets/personal;
        recursive = false;
      };
    })

  ]);
}
