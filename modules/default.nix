{ }:
{
  home = {
    imports = [
      ./hm-darwin-setup.nix

      ./git.nix
      ./fzf.nix

      ./zsh
      ./tmux
      ./emacs
      ./iTerm2
      ./z-lua
      ./xdg-more
      ./vscode
    ];
  };

  darwin = {
    imports = [ ./darwin ];
  };
}
