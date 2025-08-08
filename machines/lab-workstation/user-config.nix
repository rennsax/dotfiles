{ pkgs, ... }:
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
      ];
    };
    fzf.enable = true;
    z-lua = {
      enable = true;
      enableAliases = true;
    };
    tmux.enable = true;
    tmux.oh-my-tmux.enable = true;
    iterm2.enable = true;
    emacs-libvterm.enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    bat
    fd
    ripgrep
    tree
    rlwrap
    p7zip
    jq
    cheat
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  xdg.configFile."starship.toml".source = ./text/starship.toml;

  home.stateVersion = "25.05";
}
