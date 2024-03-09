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

# The needrestart(1) prompts are annoying.
# Simply export NEEDRESTART_MODE=a or NEEDRESTART_SUSPEND=1
# or DEBIAN_FRONTEND=noninteractive is useless,
# because sudo doesn't perserve the environment varibles (unless w/ -E option)
if [ -f "/etc/needrestart/needrestart.conf" ]; then
    # disable kernel checks && restart_mode = (a)utomatically
    printf "%s\n" "\$nrconf{kernelhints} = 0;" "\$nrconf{restart} = 'a';" | \
        sudo tee -a /etc/needrestart/needrestart.conf >/dev/null
fi
if [ "${INSTALL_DEBIAN_NO_SJTU_SOURCES}" -ne 1 ]; then
    alter_apt_sources || error_exit "failed to alter apt sources"
fi

info "update packages"
if [ "${INSTALL_DEBIAN_TRACE}" -eq 1 ]; then
    sudo apt-get update -y
    sudo apt-get upgrade -y
else
    sudo apt-get update -y >/dev/null 2>&1
    sudo apt-get upgrade -y >/dev/null 2>&1
fi

PACKAGES="man zsh git xz-utils curl tmux"
PACKAGES="${PACKAGES} fzf neovim fd-find tree lua5.4"
PACKAGES="${PACKAGES} $(printf "%s" "$DEBIAN_EXTRA_PACKAGES" | tr ':' ' ')"

IFS=" "
for package in $PACKAGES; do
    info "installing package: $package..."
    if [ "${INSTALL_DEBIAN_TRACE}" -eq 1 ]; then
        int_exit_eval sudo apt-get install "$package" -y \
            || error_report "failed to install $package"
    else
        int_exit_eval sudo apt-get install "$package" >/dev/null 2>&1 -y \
            || error_report "failed to install $package"
    fi
done

has fdfind && ln -sf "$(which fdfind)" ~/.local/bin/fd

# starship
if ! has starship; then
    info "installing starship..."
    if during_ci; then
        curl -sS https://starship.rs/install.sh | FORCE=1 sh
    else
        curl -sS https://starship.rs/install.sh | sh
    fi
fi

# zsh: set ZDOTDIR
# shellcheck disable=SC2016
printf 'export ZDOTDIR="$HOME/.config/zsh"\n' | sudo tee -a /etc/zsh/zshenv >/dev/null

info "Setting up zsh as default shell:"
during_ci || chsh -s "$(which zsh)"
