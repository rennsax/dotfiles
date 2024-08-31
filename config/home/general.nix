# Home configurations that are invariant at most of the time.
# This output should be merged into any other modules.
# Type: plugin (but necessary!).
{
  inputs, # Flake input
  config,
  pkgs,
  lib,
  myVars,
  ...
}:

let
  username = myVars.me.username;
in
{
  myModules = {
    git.enable = true;
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      plugins = [
        "zsh-syntax-highlighting"
        "zsh-autosuggestions"
        "zsh-completions"
        "git"
      ];
    };
    emacs-libvterm.enableZshIntegration = true;
  };

  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    flake-utils.flake = inputs.flake-utils;
    home-manager.flake = inputs.home-manager;
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory =
    if pkgs.hostPlatform.isDarwin then "/Users/${username}" else "/home/${username}";

  home.sessionVariables = {
    EDITOR = lib.mkDefault "\${EDITOR:-nano}";
    PAGER = lib.mkDefault "\${PAGER:-less -iR}";
  };

  # Will pollute `home.sessionVariables`
  xdg.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
