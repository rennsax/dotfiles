#!/usr/bin/env sh

set -e

alter_apt_sources() {
    arch=$(which_arch)

    case "$arch" in
        aarch64 )
            sudo sed -i 's@ports.ubuntu.com@mirror.sjtu.edu.cn@g' /etc/apt/sources.list
            ;;
        x86_64 )
            sudo sed -i 's@archive.ubuntu.com@mirror.sjtu.edu.cn@g' /etc/apt/sources.list
            ;;
        * )
            error_report "Unsupported arch: %s\n" "$arch" >&2
            return 1
    esac
}

: "${INSTALL_DEBIAN_NO_SJTU_SOURCES:=0}"
: "${INSTALL_DEBIAN_TRACE:=0}"

if [ "${INSTALL_DEBIAN_NO_SJTU_SOURCES}" -ne 1 ]; then
    alter_apt_sources || error_exit "failed to alter apt sources"
fi

info "update packages"
if [ "${INSTALL_DEBIAN_TRACE}" -eq 1 ]; then
    sudo apt-get update -y
    sudo apt-get upgrade -y
else
    sudo apt-get update -y >/dev/null
    sudo apt-get upgrade -y >/dev/null
fi

PACKAGES="man zsh git xz-utils curl"
PACKAGES="${PACKAGES} fzf neovim fd-find tree lua5.4"
PACKAGES="${PACKAGES} $(printf "%s" "$DEBIAN_EXTRA_PACKAGES" | tr ':' ' ')"

IFS=" "
for package in $PACKAGES; do
    info "installing package: $package..."
    if [ "${INSTALL_DEBIAN_TRACE}" -eq 1 ]; then
        int_exit_eval sudo apt-get install "$package" -y \
            || error_report "failed to install $package"
    else
        int_exit_eval sudo apt-get install "$package" >/dev/null -y \
            || error_report "failed to install $package"
    fi
done

has fdfind && ln -sf "$(which fdfind)" ~/.local/bin/fd

# starship
if ! has starship; then
    info "installing starship..."
    curl -sS https://starship.rs/install.sh | sh
fi

# zsh: set ZDOTDIR
# shellcheck disable=SC2016
printf 'export ZDOTDIR="$HOME/.config/zsh"\n' | sudo tee -a /etc/zsh/zshenv >/dev/null

info "Setting up zsh as default shell:"
chsh -s "$(which zsh)"
