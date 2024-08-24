# Basic home configurations. Satisfy my daily workflow.
# Type: slot.
{
  lib,
  config,
  pkgs,
  myVars,
  ...
}:
{
  myModules = {
    starship.enable = true;
    cheat.enable = true;
    cheat._enableEditableCheatsheets = true;
    git.enable = true;
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      defer.enable = true;
      extraPlugins = [ "vterm" ];
      plugins = [
        "zsh-syntax-highlighting"
        "zsh-autosuggestions"
        "zsh-completions"
        "tmux"
        "git"
        # Provides completions for docker and kubectl.
        (lib.mkIf config.myModules.orbstack.enable "orb")
      ];
    };
    fzf.enable = true;
    tmux.enable = true;
    z-lua = {
      enable = true;
      enableAliases = true;
    };
    iterm2.enable = true;
    xdg = {
      npm.enable = true;
      go.enable = true;
    };
  };

  home.language = {
    base = "en_US.UTF-8";
  };

  home.packages =
    with pkgs;
    [
      bat
      curl
      dust
      fd
      htop
      ripgrep
      tree
      rlwrap # Readline wrapper
      p7zip
      wget
      jq
    ]
    ++ lib.optionals myVars.isDarwin [ macos-trash ]
    ++ lib.optionals myVars.isLinux [ trash-cli ];

  home.extraOutputsToInstall = [
    "info"
    "man"
  ];

  programs.man = {
    enable = true;
    generateCaches = true;
    package = pkgs.man; # nongnu man-db
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh.sessionVariables = {
    # Disable regular load/unload messages.
    DIRENV_LOG_FORMAT = "";
  };

}
