{ }:
{
  home =
    let
      baseModules = [
        ./cheat/cheat.nix
        ./starship/starship.nix
        ./git.nix
        ./zsh/zsh.nix
        ./tmux/tmux.nix
      ];
      darwinModules = [ ./hammerspoon/hammerspoon.nix ];
      makeSubModule = modules: { imports = modules; };
    in
    {
      base = makeSubModule baseModules;
      darwin = makeSubModule darwinModules;
    };

  darwin = {
    imports = [ ./darwin ];
  };
}
