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
    ];
  };

  darwin = {
    imports = [ ./darwin ];
  };
}
