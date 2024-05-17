#!/usr/bin/env sh

set -e

[ "$(basename "$PWD")" = "dotfiles" ] || [ "$(basename "$PWD")" = ".dotfiles" ] || {
    printf "%s\n" "Please run this script from the .dotfiles directory." >&2
    exit 1
}

XDG_CONFIG_HOME="$HOME/.config"
XDG_BIN_HOME="$HOME/.local/bin"
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
    # starship: on Linux, the default C/C++ compiler is gcc/g++
    sed -i 's|clang++|g++|;s|clang|gcc|' "$XDG_CONFIG_HOME/starship.toml"

    # The minimal nvim configurations
    mkdir "$XDG_CONFIG_HOME"/nvim
    # From lua configurations, extract the Vimscript parts
    find nvim/lua/configs -type f -exec grep -- '-- <VIM> ' '{}' \; |
        sed 's|^-- <VIM> ||g' > "$XDG_CONFIG_HOME/nvim/init.vim"
    # TODO: add pre-commit script to check the line number
    test "$(wc -l < "$XDG_CONFIG_HOME/nvim/init.vim")" -eq 82
}

macos_specified() {
    # Directly symlink the nvim configurations.
    force_ln_folder "$DOTFILES_HOME/nvim" "$XDG_CONFIG_HOME"/

    # pet
    force_ln_folder "$DOTFILES_HOME/pet" "$XDG_CONFIG_HOME"/

    # cheat
    mkdir -p "$XDG_CONFIG_HOME"/cheat/cheatsheets
    force_ln_folder "$DOTFILES_HOME/cheat/cheatsheets/personal" "$XDG_CONFIG_HOME"/cheat/cheatsheets/

    # nnm
    force_ln_folder "$DOTFILES_HOME/nnn/plugins" "$XDG_CONFIG_HOME"/nnn/

    # yabai
    force_ln_folder "$DOTFILES_HOME/yabai/yabai" "$XDG_CONFIG_HOME"/
    force_ln_folder "$DOTFILES_HOME/yabai/skhd" "$XDG_CONFIG_HOME"/
}

orb_extra_init() {
    # shellcheck disable=SC2016
    mac_home="$(mac sh -c 'printf "%s" $HOME')"

    # Directly symlink .gitconfig
    ln -sf "$mac_home/.gitconfig" "$HOME"/

    # Install a special utility which effectively runs trash command on the mac
    # (since trash-cli cannot act perfectly on an orb VM)
    # See https://specifications.freedesktop.org/trash-spec/trashspec-latest.html
    cat <<'EOF' > "$XDG_BIN_HOME/trash-mac"
#!/usr/bin/env sh

usage() {
    printf "Usage: %s <path> [...]\n" "$(basename "$0")" >&2
    printf "A wrapper script for orbstack VM which runs trash command on the mac.\n" >&2
    exit 0
}

main() {
    mac trash "$@"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
fi

main "$@"
EOF
    chmod +x "$XDG_BIN_HOME/trash-mac"
}

is_orb_vm() {
    uname -r | grep -q 'orbstack'
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
if [ -d "$XDG_CONFIG_HOME/nvim" ]; then
    printf "%s\n" "[warning] backup original nvim configurations"
    mv "$XDG_CONFIG_HOME/nvim" "$XDG_CONFIG_HOME/nvim.backup-$(date +%s)"
fi

# z.lua
mkdir -p "$XDG_CONFIG_HOME"/zlua

# cpp-dev
ln -sf "$DOTFILES_HOME/cpp-dev/.clang-format" "$DOTFILES_HOME/cpp-dev/.clang-tidy" \
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

if is_orb_vm; then
    orb_extra_init
fi
