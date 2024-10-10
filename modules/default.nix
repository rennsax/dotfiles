{ }:
{
  home = {
    imports = [
      ./hm-darwin-setup.nix

      ./git.nix
      ./fzf.nix

      ./cheat
      ./starship
      ./zsh
      ./tmux
      ./hammerspoon
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
