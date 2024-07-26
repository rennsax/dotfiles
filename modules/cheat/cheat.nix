{
  pkgs,
  lib,
  config,
  myLib,
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
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."cheat/cheatsheets/personal" = {
      source = ./cheatsheets/personal;
      recursive = false;
    };

    xdg.configFile."cheat/cheatsheets/community" = {
      source = pkgs.fetchFromGitHub {
        owner = "cheat";
        repo = "cheatsheets";
        rev = "36bdb99";
        sha256 = "sha256-Afv0rPlYTCsyWvYx8UObKs6Me8IOH5Cv5u4fO38J8ns=";
      };
      recursive = false;
    };

    xdg.configFile."cheat/conf.yml" = {
      text = ''
        colorize: false
        style: monokai
        formatter: terminal256
        pager: ${pkgs.bat}/bin/bat -lbash
        cheatpaths:
          - name: community
            path: ${config.xdg.configHome}/cheat/cheatsheets/community
            tags: [ community ]
            readonly: true

          - name: personal
            path: ${config.xdg.configHome}/cheat/cheatsheets/personal
            tags: [ personal ]
            readonly: false
      '';
    };
  };
}
