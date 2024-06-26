# Global environment variables.

# Home Manager. I don't want to manage your shell through Home Manager so I have
# to manually source 'hm-session-vars.sh'
[[ -f ~"/.nix-profile/etc/profile.d/hm-session-vars.sh" ]] && . ~"/.nix-profile/etc/profile.d/hm-session-vars.sh"

# macOS: `systemsetup -listtimezones`
export TZ=Asia/Shanghai

# The following variables are not specified by XDG standard.
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_MAN_PATH="$HOME/.local/share/man"

export PATH="$XDG_BIN_HOME:$PATH"

# pipx
# TODO: legacy in Nix system
export PIPX_HOME="$XDG_DATA_HOME/pipx"
export PIPX_BIN_DIR="$XDG_BIN_HOME"
export PIPX_MAN_DIR="$XDG_MAN_PATH"

# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc

# asdf-vm
export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME}/asdf/asdfrc"
export ASDF_DATA_DIR="${XDG_DATA_HOME}/asdf"
