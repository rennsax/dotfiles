{ }:
{
  home = {
    imports = [
      ./git.nix
      ./fzf.nix

      ./cheat
      ./starship
      ./zsh
      ./tmux
      ./hammerspoon
      ./orbstack
      ./emacs
    ];
  };

  darwin = {
    imports = [ ./darwin ];
  };
}
