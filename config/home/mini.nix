# Minimal home configurations. Only covers necessary tools.
# Type: slot.
{
  pkgs,
  ...
}:
{
  myModules = {
    starship.enable = true;
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

  home.packages = with pkgs; [
    bat
    htop
    fd
    tree
    ripgrep
  ];

  programs.man = {
    enable = true;
    generateCaches = true;
    package = pkgs.man; # nongnu man-db
  };
}
