{ }:
{
  home = {
    imports = [
      ./hm-darwin-setup.nix

      ./git.nix
      ./fzf.nix

      ./zsh
      ./tmux
      ./orbstack
      ./emacs
      ./iTerm2
      ./z-lua
      ./xdg-more
    ];
  };

  darwin = {
    imports = [ ./darwin ];
  };
}
