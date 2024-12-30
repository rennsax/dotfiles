# Shell integration logic is copied from https://github.com/nix-community/home-manager/blob/635563f245309ef5320f80c7ebcb89b2398d2949/modules/programs/starship.nix.
{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.myModules.iterm2;

  shellIntegrationScriptFor = shell: (pkgs.callPackage ./iterm2-shell-integration.nix { }).${shell};

  shellIntegrationFor = shell: ''
    ${optionalString cfg.enableShellIntegrationWithTmux "ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=1"}
    source ${shellIntegrationScriptFor shell}
  '';

  utilities = pkgs.callPackage ./iterm2-utilities.nix { };
  AIplugin = pkgs.callPackage ./iterm2-ai.nix { };

in
{
  options.myModules.iterm2 = {
    enable = mkEnableOption "iterm2";
    enableUtilities = mkEnableOption "iterm2 utilities" // {
      default = true;
    };
    withAI = mkEnableOption "install AI plugin";
    package = mkOption {
      type = types.package;
      default = pkgs.iterm2;
      defaultText = literalExpression "pkgs.iterm2";
      description = "The package to use for the iterm2 cask.";
    };
    enableInstall = mkEnableOption "whether to install iTerm2" // {
      default = pkgs.stdenv.isDarwin;
    };
    enableBashIntegration = mkEnableOption "Bash integration" // {
      default = true;
    };
    enableZshIntegration = mkEnableOption "Zsh integration" // {
      default = true;
    };
    enableFishIntegration = mkEnableOption "Fish integration" // {
      default = true;
    };
    enableShellIntegrationWithTmux = mkEnableOption "Shell integration with Tmux" // {
      default = true;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {

      # Do not install iTerm2 on non-darwin system.
      home.packages = mkIf cfg.enableInstall [ cfg.package ];

      programs.bash.initExtra = mkIf cfg.enableBashIntegration (shellIntegrationFor "bash");
      programs.zsh.initExtra = mkIf cfg.enableZshIntegration (shellIntegrationFor "zsh");
      programs.fish.interactiveShellInit = mkIf cfg.enableFishIntegration (shellIntegrationFor "fish");

    }

    (mkIf cfg.enableUtilities {
      home.packages = [ utilities ];

      # initExtra is called after compinit
      programs.zsh.initExtra = optionalString cfg.enableZshIntegration ''
        compdef _ssh it2ssh=ssh
      '';
    })

    (mkIf cfg.withAI {
      home.packages = [ AIplugin ];
    })
  ]);
}
