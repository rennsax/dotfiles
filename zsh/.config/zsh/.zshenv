# very important setup

## export PATH="$HOME/bin:$PATH"

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

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

# GoLang
export GOPATH="$XDG_CACHE_HOME/go"

# Cargo
export CARGO_HOME="$XDG_CACHE_HOME/cargo"

