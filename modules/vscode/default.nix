# Home-manager module for managing VS Code.
{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.myModules.vscode;

  # Extensions only meaningful for the local environment.
  localExtensions = with pkgs.nix-vscode-extensions.vscode-marketplace-release; [
    # Keybinding
    tuttieee.emacs-mcx

    # UI
    pkief.material-icon-theme
    gruntfuggly.todo-tree
    usernamehw.errorlens

    # Killer APPs of VS Code.
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
  ];
in
{
  options.myModules.vscode = {
    enable = lib.mkEnableOption "VS Code";
    # TODO: this option is probably useless because extensions for the remote
    # vscode-server is installed in another directory that is not managed by
    # home-manager.
    remote = lib.mkEnableOption "Remote VS Code server";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      profiles.default.extensions =
        (with pkgs.nix-vscode-extensions.vscode-marketplace-release; [
          vivaxy.vscode-conventional-commits
          cschlosser.doxdocgen

          streetsidesoftware.code-spell-checker
          eamodio.gitlens

          # Languages
          timonwong.shellcheck
          jnoortheen.nix-ide
          ms-python.python
          ms-toolsai.jupyter
        ])
        ++ lib.optionals (!cfg.remote) localExtensions;

    };
  };
}
