# Shell integration logic is copied from https://github.com/nix-community/home-manager/blob/635563f245309ef5320f80c7ebcb89b2398d2949/modules/programs/starship.nix.
{
  pkgs,
  lib,
  config,
  myLib,
  ...
}:
with lib;
let
  cfg = config.myModules.iterm2;

  shellIntegrationScriptFor =
    shell:
    let
      hashes = {
        zsh = "sha256-Cq8winA/tcnnVblDTW2n1k/olN3DONEfXrzYNkufZvY=";
        bash = "sha256-gHSOANRhOVHLjFSzPZNG2GQ0xlFkLt5P277jwWYGgs8=";
        fish = "sha256-29XvF/8KGd63NOAqWPoxODPQAMA8gNr+MIHFEqcKov4=";
        # tcsh = "sha256-5AnLEnmobiv3GwIgXO12Jt0ugUZGb8A0KyyeFjfG1UI=";
      };
    in
    pkgs.fetchurl {
      name = "iterm2-${shell}-integration";
      url = "https://iterm2.com/shell_integration/${shell}";
      hash = hashes.${shell};
    };

  shellIntegrationFor = shell: ''
    ${optionalString cfg.enableShellIntegrationWithTmux "ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=1"}
    source ${shellIntegrationScriptFor shell}
  '';

in
{
  options.myModules.iterm2 = {
    enable = mkEnableOption "iterm2";
    package = mkOption {
      type = types.package;
      default = pkgs.iterm2;
      defaultText = literalExpression "pkgs.iterm2";
      description = "The package to use for the iterm2 cask.";
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

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];
    programs.bash.initExtra = mkIf cfg.enableBashIntegration (shellIntegrationFor "bash");
    programs.zsh.initExtra = mkIf cfg.enableZshIntegration (shellIntegrationFor "zsh");
    programs.fish.interactiveShellInit = mkIf cfg.enableFishIntegration (shellIntegrationFor "fish");

  };
}
