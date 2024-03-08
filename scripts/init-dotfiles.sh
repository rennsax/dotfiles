#!/usr/bin/env sh

set -e

linux_specified() {
    sed -i 's|clang++|g++|;s|clang|gcc|' "$XDG_CONFIG_HOME/starship.toml"
}

orb_extra_init() {
    # shellcheck disable=SC2016
    mac_home="$(mac sh -c 'printf "%s" $HOME')"
    ln -sf "$mac_home/.gitconfig" "$HOME"/
}

XDG_CONFIG_HOME="$HOME/.config"
ZDOTDIR="$XDG_CONFIG_HOME/zsh"

mkdir -p "$ZDOTDIR"

[ "$(basename "$PWD")" = ".dotfiles" ] || {
    printf "%s\n" "Please run this script from the .dotfiles directory." >&2
    exit 1
}

DOTFILES_HOME="$PWD"

ln -sf "$DOTFILES_HOME/zsh/.config/zsh/.zshenv" \
    "$DOTFILES_HOME/zsh/.config/zsh/.zshrc" \
    "$DOTFILES_HOME/zsh/.config/zsh/.zshrc-debian" \
    "$ZDOTDIR"/

ln -sfn "$DOTFILES_HOME/zsh/.config/zsh/.zsh-plugins" "$ZDOTDIR"/

mkdir -p "$XDG_CONFIG_HOME"/nvim

ln -sf "$DOTFILES_HOME/nvim/.config/nvim/_init.vim" "$XDG_CONFIG_HOME"/nvim/init.vim

# "starship.toml" is platform-dependent, so copy it
rm -f "$XDG_CONFIG_HOME"/starship.toml
cp -f "$DOTFILES_HOME/starship/.config/starship.toml" "$XDG_CONFIG_HOME"/

ln -sfn "$DOTFILES_HOME/tmux/.config/tmux" "$XDG_CONFIG_HOME"/

# If the script is run by an orb virtual machine, do extra things
command -v mac >/dev/null 2>&1 && orb_extra_init
[ "$(uname -s | tr '[:upper:]' '[:lower:]')" = 'linux' ] && linux_specified