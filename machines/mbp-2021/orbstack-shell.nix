# Shell integration for Orbstack.
# After opening Orbstack.app for the first time, it pollutes the system by:
#
#     1. Create symbolic links under /usr/local/bin
#     2. Create ~/.orbstack and ~/.docker, if they do not exit.
#     3. Create $ZDOTDIR/.zprofile and add scripts to initialize zsh completion.
#
# You can revert these changes if you don't like them.
#
# Since it's so impure, I do not include the orbstack package here. Recommended:
# manually install it.
{ lib, ... }:
with lib;
let
  # Modify PATH and provides completion functions for docker/kubectl.
  # Must be sourced before compinit.
  shellInitFor = shell: ''
    source ~/.orbstack/shell/init.${shell}
  '';
in
{
  # Put this before my personal configuration, so the orb.plugin.zsh can be correctly loaded.
  programs.zsh.initContent = mkMerge [
    (mkOrder 550 (shellInitFor "zsh"))
    # Setup orb/orbctl completion. Must be after compinit.
    (''
      # make sure you execute this *after* asdf or other version managers are loaded
      eval "$(orbctl completion zsh)" # declare `_orbctl` function
      compdef _orbctl orbctl
      compdef _orbctl orb
    '')
  ];
}
