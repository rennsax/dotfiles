#!/usr/bin/env sh

set -e

# From https://unix.stackexchange.com/a/6348
export_linux_distro() {
    if [ -f /etc/os-release ]; then
        # freedesktop.org and systemd
        # shellcheck disable=SC1091
        . /etc/os-release
        LINUX_DISTRO=$NAME
        LINUX_DISTRO_VER=$LINUX_DISTRO_VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        LINUX_DISTRO=$(lsb_release -si)
        LINUX_DISTRO_VER=$(lsb_release -sr)
    elif [ -f /etc/lsb-release ]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        # shellcheck disable=SC1091
        . /etc/lsb-release
        LINUX_DISTRO=$DISTRIB_ID
        LINUX_DISTRO_VER=$DISTRIB_RELEASE
    elif [ -f /etc/debian_version ]; then
        # Older Debian/Ubuntu/etc.
        LINUX_DISTRO=Debian
        LINUX_DISTRO_VER=$(cat /etc/debian_version)
    else
        # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
        LINUX_DISTRO=$(uname -s)
        LINUX_DISTRO_VER=$(uname -r)
    fi
    LINUX_DISTRO=$(printf "%s" "$LINUX_DISTRO" | tr '[:upper:]' '[:lower:]')
    export LINUX_DISTRO LINUX_DISTRO_VER
}

# Possible return values:
#   - i686
#   - x86_64
#   - arm
#   - arm64
which_arch() {
  arch="$(uname -m | tr '[:upper:]' '[:lower:]')"

  case "${arch}" in
    amd64) arch="x86_64" ;;
    armv*) arch="arm" ;;
    arm64) arch="aarch64" ;;
  esac

  # `uname -m` in some cases mis-reports 32-bit OS as 64-bit, so double check
  if [ "${arch}" = "x86_64" ] && [ "$(getconf LONG_BIT)" -eq 32 ]; then
    arch=i686
  elif [ "${arch}" = "aarch64" ] && [ "$(getconf LONG_BIT)" -eq 32 ]; then
    arch=arm
  fi

  printf '%s' "${arch}"
}

do_install() {
    mkdir -p ~/.local/bin ~/.local/state ~/.config ~/.local/share/man
    PROMPT="install-$1"
    info() {
        printf "[$PROMPT] %s\n" "$@"
    }
    error_report() {
        printf "[$PROMPT] %s\n" "$@" >&2
    }
    error_exit() {
        error_report "$@"
        exit 1
    }
    # shellcheck disable=SC1090
    . "./scripts/install-$1.sh"
}

int_exit_eval() {
    ec=0
    "$@" || ec=$?
    if [ "$ec" -eq 130 ]; then
        error_exit "cancelled by user"
    else
        return "$ec"
    fi
}

has() {
  command -v "$1" 1>/dev/null 2>&1
}

install_linux() {
    export_linux_distro
    case "$LINUX_DISTRO" in
        ubuntu|debian )
            do_install debian ;;
        * )
            printf "Unsupported Linux distro: %s\n" "$LINUX_DISTRO" >&2
            exit 1
    esac
}

PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')

case "$PLATFORM" in
    darwin )
        do_install darwin ;;
    linux )
        install_linux ;;
    * )
        printf "Unsupported platform: %s\n" "$PLATFORM" >&2
        exit 1 ;;
esac
