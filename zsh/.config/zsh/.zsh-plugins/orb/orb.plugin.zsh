# https://raw.githubusercontent.com/orbstack/orbstack/main/orb.plugin.zsh
# make sure you execute this *after* asdf or other version managers are loaded
if (( $+commands[orbctl] )); then
  eval "$(orbctl completion zsh)"
  compdef _orb orbctl
  compdef _orb orb
fi