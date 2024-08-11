{ ... }:
{
  imports = [ ./emacs-deps.nix ];

  home.sessionVariables = {
    # TODO: enable Emacs to startup at "simple" mode.
    EDITOR = "\${EDITOR:-emacs -Q -nw}";
  };
}
