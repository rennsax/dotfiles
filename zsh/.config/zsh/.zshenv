# very important setup

# redirect shouldn't overwrite a existing file
setopt noclobber

# Default editor
export EDITOR=nvim

# Manually set your language environment
export LANG=en_US.UTF-8

# Proxy settings
CLASH_MIXED_PORT=8881
export http_proxy="http://127.0.0.1:${CLASH_MIXED_PORT}"
export https_proxy="http://127.0.0.1:${CLASH_MIXED_PORT}"

# XDG standard, see https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
# The following variables are not specified by XDG standard.
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_MAN_PATH="$HOME/.local/share/man"

export PATH="$XDG_BIN_HOME:$PATH"

# GoLang
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"

# Cargo
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# pipx
export PIPX_HOME="$XDG_DATA_HOME/pipx"
export PIPX_BIN_DIR="$XDG_BIN_HOME"
export PIPX_MAN_DIR="$XDG_MAN_PATH"

# rbenv
export RBENV_ROOT="$XDG_DATA_HOME"/rbenv

