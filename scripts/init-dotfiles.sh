#!/usr/bin/env sh

set -e

[ "$(basename "$PWD")" = "dotfiles" ] || [ "$(basename "$PWD")" = ".dotfiles" ] || {
    printf "%s\n" "Please run this script from the .dotfiles directory." >&2
    exit 1
}

XDG_CONFIG_HOME="$HOME/.config"
ZDOTDIR="$XDG_CONFIG_HOME/zsh"
DOTFILES_HOME="$PWD"

force_ln_folder() {
    src=$1
    dst=$2

    if ! ln -sfn "$src" "$dst" 2>/dev/null; then
        dst=$(cd "$dst" && pwd)
        dst="$dst/$(basename "$src")"
        [ -d "$dst" ] && {
            printf "[warning] overwrite folder: %s\n" "$dst"
            rm -rf "$dst"
        }
        ln -sfn "$src" "$dst"
    fi
}

linux_specified() {
    sed -i 's|clang++|g++|;s|clang|gcc|' "$XDG_CONFIG_HOME/starship.toml"
    ln -sf "$DOTFILES_HOME/nvim/_init.vim" "$XDG_CONFIG_HOME"/nvim/init.vim
}

macos_specified() {
    ln -sf "$DOTFILES_HOME/nvim/_init.vim" \
        "$DOTFILES_HOME/nvim/init.lua" \
        "$XDG_CONFIG_HOME"/nvim/
    force_ln_folder "$DOTFILES_HOME/nvim/lua" "$XDG_CONFIG_HOME"/nvim/

    # pet
    force_ln_folder "$DOTFILES_HOME/pet" "$XDG_CONFIG_HOME"/

    # cheat
    mkdir -p "$XDG_CONFIG_HOME"/cheat/cheatesheets
    force_ln_folder "$DOTFILES_HOME/cheatesheets/personal" "$XDG_CONFIG_HOME"/cheat/cheatesheets/

    # nnm
    force_ln_folder "$DOTFILES_HOME/nnn/plugins" "$XDG_CONFIG_HOME"/nnn/

    # yabai
    force_ln_folder "$DOTFILES_HOME/yabai/yabai" "$XDG_CONFIG_HOME"/
    force_ln_folder "$DOTFILES_HOME/yabai/skhd" "$XDG_CONFIG_HOME"/
}

orb_extra_init() {
    # shellcheck disable=SC2016
    mac_home="$(mac sh -c 'printf "%s" $HOME')"
    ln -sf "$mac_home/.gitconfig" "$HOME"/
}

# zsh
mkdir -p "$ZDOTDIR"
ln -sf "$DOTFILES_HOME/zsh/.zshenv" \
    "$DOTFILES_HOME/zsh/.zshrc" \
    "$DOTFILES_HOME/zsh/.zshrc-debian" \
    "$DOTFILES_HOME/zsh/.zshrc-darwin" \
    "$ZDOTDIR"/
force_ln_folder "$DOTFILES_HOME/zsh/.zsh-plugins" "$ZDOTDIR"/

# starship
# "starship.toml" is platform-dependent, so copy it
rm -f "$XDG_CONFIG_HOME"/starship.toml
cp -f "$DOTFILES_HOME/starship/starship.toml" "$XDG_CONFIG_HOME"/

# tmux
force_ln_folder "$DOTFILES_HOME/tmux" "$XDG_CONFIG_HOME"/

# npm
mkdir -p "$XDG_CONFIG_HOME"/npm
ln -sf "$DOTFILES_HOME/npm/npmrc" "$XDG_CONFIG_HOME"/npm/

# nvim
mkdir -p "$XDG_CONFIG_HOME"/nvim

# cpp-dev
ln -sf "$DOTFILES_HOME/.clang-format" "$DOTFILES_HOME/.clang-tidy" \
    "$HOME/"

# extra actions
case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
    darwin )
        macos_specified
        ;;
    linux )
        linux_specified
        ;;
esac

if command -v mac >/dev/null; then
    orb_extra_init
fi
