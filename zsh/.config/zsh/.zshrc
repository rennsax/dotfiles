# vim: set ft=zsh:
# (modeline magic)

############################################################
#################### NOTE ##################################
############################################################
#
# 1. When possible, install packages with Homebrew.
# 2. In the following cases, in favor of `alias` rather than `function`:
#    - Claim default options for the commands.
#    - Use the abbreviation in interactive mode most of the time.
# 3. In the following cases, in favor of `function` rather than `alias`:
#    - Complex routines.
#    - Need to be reused even when writing shell scripts.
# 4. Use `word ... () { list }` to define functions as possible, which is more compatible.
# 5. Do not override commands via aliasing unless you want to abandon the previous version.
#    It prevent the nesting of aliasing, and is not what you expect at most of the time.
# 6. Use `#` as the leading character of descriptions, and `##` of commented codes.
#

if [[ ! -d $ZDOTDIR ]]; then
    echo "refuse to load .zshrc since ZDOTDIR is invalid" >&2
    return 1
fi

autoload -Uz $ZDOTDIR/.zsh-plugins/zsh-defer/zsh-defer

load_plugin() {
    emulate -L zsh
    local plugin="$1"
    if [[ -s "$ZDOTDIR/.zsh-plugins/$plugin/$plugin.plugin.zsh" ]]; then
        zsh-defer source "$ZDOTDIR/.zsh-plugins/$plugin/$plugin.plugin.zsh"
    else
        echo "zsh: plugin $plugin not found"
    fi
}

#################### Homebrew (MacOS) ######################

export HOMEBREW_NO_AUTO_UPDATE=1

# Firstly, set PATH so `brew` can be found.
export PATH="/opt/homebrew/bin:$PATH"
HOMEBREW_PREFIX="$(brew --prefix)"
HOMEBREW_COMPLETIONS="${HOMEBREW_PREFIX}/share/zsh/site-functions"

# llvm
export LLVM_BIN_PATH="${HOMEBREW_PREFIX}/opt/llvm/bin"
export PATH="$LLVM_BIN_PATH:$PATH"
export CC="$LLVM_BIN_PATH/clang"
export CXX="$LLVM_BIN_PATH/clang++"

# python@3.12
export PYTHON3_BIN_PATH="${HOMEBREW_PREFIX}/opt/python@3.12/libexec/bin"
export PATH="$PYTHON3_BIN_PATH:$PATH"

# xxutils: from GNU. If the binaries are prepended `g`, denoted by "<g>"

# binutils (key-only)
export GNU_BINUTILS_BIN_PATH="${HOMEBREW_PREFIX}/opt/binutils/bin"

# coreutils <g>
export GNU_COREUTILS_BIN_PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin"

# findutils <g>
export GNU_FINDUTILS_BIN_PATH="${HOMEBREW_PREFIX}/opt/findutils/libexec/gnubin"

# diffutils: already link to homebrew prefix, use it directly

# gnu-sed <g>
export GNU_SED_BIN_PATH="${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin"

# gnu-tar <g>
export GNU_TAR_BIN_PATH="${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin"

# z.lua
ZLUA_PATH="$(brew --prefix z.lua)/share/z.lua/z.lua"
export _ZL_DATA="${XDG_CONFIG_HOME:-$HOME/.config}/zlua/.zlua"
eval "$(lua "${ZLUA_PATH}" --init zsh fzf enhanced once)"

# jd-gui (cask)
alias jd-gui='java -jar /Applications/JD-GUI.app/Contents/Resources/Java/jd-gui-1.6.6-min.jar >& /dev/null &|'

# fzf
FZF_BASE="$HOMEBREW_PREFIX/opt/fzf"

# cheat
if [[ "$HOMEBREW_COMPLETIONS/_cheat" -ot "$HOMEBREW_COMPLETIONS/cheat.zsh" ]]; then
    ln -sf './cheat.zsh' "$HOMEBREW_COMPLETIONS/_cheat"
elif [[ ! -f "$HOMEBREW_COMPLETIONS/cheat.zsh" ]]; then
    echo "cannot create symlink of cheat.zsh" >&2
fi

# asdf
zsh-defer source $(brew --prefix asdf)/libexec/asdf.sh

# pipx uses a legacy, incorrect autoload file. We must source it.
zsh-defer source "${HOMEBREW_COMPLETIONS}/_pipx"

# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
FPATH="${HOMEBREW_COMPLETIONS}:${FPATH}"

#################### Linuxify (MacOS) ######################

# most Linux distro has a separate utility `hd`
# hexdump is included in util-linux
alias hd='hexdump -C'

alias objdump="$GNU_BINUTILS_BIN_PATH/objdump"

alias ls='ls --color=auto'

# GNU find, locate, updatedb, xargs; sed; tar
export PATH="$GNU_FINDUTILS_BIN_PATH:$PATH"
export PATH="$GNU_SED_BIN_PATH:$PATH"
export PATH="$GNU_TAR_BIN_PATH:$PATH"

# brew install x86_64-elf-gdb
alias gdb='x86_64-elf-gdb'

#################### Shortcuts #############################

alias debug_zsh='DEBUG_ZSH=1 zsh -x'

# git log
# https://github.com/ohmyzsh/ohmyzsh/blob/80c114cb3a64044ea50b623f96a35bc022db5e8d/plugins/git/git.plugin.zsh#L224-L238
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias glo='git log --oneline --decorate'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'

# docker compose
alias dcpsu='docker compose up'
alias dcpsud='docker compose up -d'
alias dcpsd='docker compose down'

# pip3 install ... from_tuna
alias -g from_tuna="-i https://pypi.tuna.tsinghua.edu.cn/simple"

alias cmake-clean='cmake --build build --target clean'

# rsync
alias rsync-copy="rsync -avz --progress -h"
alias rsync-move="rsync -avz --progress -h --remove-source-files"
alias rsync-update="rsync -avzu --progress -h"
alias rsync-synchronize="rsync -avzu --delete --progress -h"

# z.lua
alias zb='z -b'
alias zi='z -I'

# prefer Inter syntax disassemble
alias objdumpi='objdump -M intel'

#################### Misc. (Portable) ######################

# `-i`: smart case insensitive
## export MANPAGER="less -sRi"
export MANPAGER='nvim +Man!'

# git-repo
export REPO_URL='https://mirrors.tuna.tsinghua.edu.cn/git/git-repo'

# bat
export BAT_THEME="gruvbox-dark"
alias cat='bat'

# trash-cli
alias rm='echo "This is not the command you are looking for."; false'

# nnn
alias nnn='nnn -e' # always open text files in the terminal
export NNN_PLUG="p:preview-tui;z:autojump"
export NNN_FIFO="/tmp/nnn.fifo"
export NNN_ZLUA="${ZLUA_PATH}"
export NNN_TRASH=1

# nvim
export NVIM_INSTALL_PLUGINS=1

# fzf rebind TAB (^I), so it must be inited after `compinit` (defer it).
# zsh-defer can even defer the task when __fzf_setup isn't defined.
zsh-defer __fzf_setup "$FZF_BASE"
zsh-defer loadpnpm

#################### Misc. (MacOS) #########################

# TODO: iterm2

#################### Routines ##############################

loadpnpm() {
    # pnpm tabtab completions
    export PNPM_HOME="$XDG_DATA_HOME/pnpm"
    export PATH="$PNPM_HOME:$PATH"
    [[ -f "$XDG_CONFIG_HOME/tabtab/zsh/__tabtab.zsh" ]] && \
        \. "$XDG_CONFIG_HOME/tabtab/zsh/__tabtab.zsh"
}

# setup shell environment for conda
loadconda() {
    local __conda_setup
    __conda_setup="$(command conda "shell.zsh" hook 2>/dev/null)"
    if (( $? )); then
        echo 'cannot find `conda` executable' >&2
    else
        eval "$__conda_setup"
        echo 'successfully init conda environment'
    fi
}

# fzf
# Setup completion, keybindings for fzf.
# The funtion is defered until completion system is inited.
# PARAMS: FZF_BASE
__fzf_setup() {
    emulate -L zsh
    setopt err_return
    local fzf_base="$1"
    if [[ ! ( -d "$fzf_base" && -d "$fzf_base/shell" ) ]]; then
        echo "[fzf-setup] invalid base" >&2
        return 1
    fi
    local fzf_shell="$fzf_base/shell"
    source "$fzf_shell/completion.zsh"
    source "$fzf_shell/key-bindings.zsh"
    export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --strip-cwd-prefix"
    # print tree structure in the preview window
    export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
    _fzf_compgen_dir() {
        # cd **<TAB>
        fd --type d --hidden --follow --exclude ".git" --exclude "node_modules" . "$1"
    }
    _fzf_compgen_path() {
        # vim **<TAB>
        fd --hidden --follow --exclude ".git" --exclude "node_modules" . "$1"
    }
}

curl_github() {
    curl -sSLO "https://raw.githubusercontent.com/$1"
}

editz() {
    "$EDITOR" "$ZDOTDIR/.zshrc"
}

################### General Configurations #################

# allow comments when interactive
setopt interactivecomments

# ^S/^Q has no effect on start/stop the flow
setopt noflowcontrol

# history
[[ -z "$HISTFILE" ]] && export HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=10000 # leave SAVEHIST less than HISTSIZE so HIST_EXPIRE_DUPS_FIRST has
export HISTORY_IGNORE='(bye|history*)'
setopt extendedhistory        # record timestamp of command in HISTFILE
setopt histexpiredupsfirst    # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt histignoredups         # do not enter command lines into the history list if they are duplicates of the previous event.
setopt hist_ignore_space      # ignore commands that start with space (the command will linger until next command is entered)
setopt histverify             # show command with history expansion to user before running it
setopt share_history          # share command history data
alias history='fc -i -l 1'

# Dups the bash behavior: print '^C' on SIGINT
TRAPINT() {
    # -n: no newline, -u2: stderr
    print -n -u2 '^C'
    return $((128+$1))
}

#################### Directory #############################

# if a directory is placed as "command", `cd` to it
setopt autocd

setopt auto_pushd # pushd_ignore_dups
for ((i=1;i<=9;i+=1)); do alias $i="cd +$i"; done; unset i

# use GNU ls (included in coreutils) and set color
# generated via https://geoff.greer.fm/lscolors
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
# macOS ls
export LSCOLORS="Gxfxcxdxbxegedabagacad"
# -l: long listing format
# -a: all
# -A: almost all (except . and ..)
# -h: human-readable
alias l='ls -lAh'
alias ll='ls -lah'
# also enable completion color
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

#################### ZSH Line Editor #######################

# bindkey: \e == \E == ^[ == ESC, ^J == $'\C-'

# unbound keys that are used in yabai
## skhd_keys=(h j k l H J K L R Y X T F B ! @ '#' $ % ^ '&')
## for key ($skhd_keys) { bindkey -r "^[$key" }; unset skhd_keys; unset key

# https://github.com/ohmyzsh/ohmyzsh/blob/fff073b55defed72a0a1aac4e853b165f208735b/lib/key-bindings.zsh#L5-L16
# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# https://stackoverflow.com/a/1438523/17838999
WORDCHARS="'"'_-"'

# bind emacs keymapping to main
bindkey -e

# precede the current command with `#` and then accept
bindkey -M emacs '^[#' pound-insert # M-#

# accept current command, and push it to the buffer again
bindkey -M emacs '^J' accept-and-hold

# use ^X^E like bash
# create a widget with the same name so it can be invoke by ZLE
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
if [[ "$EDITOR" = *vi* ]]; then
    zstyle ':zle:edit-command-line' editor "$EDITOR" -c 'set ft=zsh'
else
    zstyle ':zle:edit-command-line' editor "$EDITOR"
fi

# magic-space: perform history expansion and insert a space
bindkey ' ' magic-space

# https://github.com/ohmyzsh/ohmyzsh/blob/fff073b55defed72a0a1aac4e853b165f208735b/lib/key-bindings.zsh#L34-L51
# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search


  bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search


  bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

################### ZSH Completions #######################

# these two options allow completions start when the cursor is within the word
# and after completion, the cursor moves to the end of the word
# for example, a_long|_wordTAB -> a_long_long_long_word|
## setopt alwaystoend completeinword

# insert the first match immediately
## setopt menu_complete
## bindkey -M menuselect -r '^I'

setopt listpacked

# completion menu
zstyle ':completion:*:*:*:*:*' menu select

# completer
zstyle ':completion:*' completer _extensions _complete _approximate

# facility: progressively increases the number of errors
zstyle ':completion:*' max-errors 2

# show a message of completer
zstyle ':completion:*' show-completer  true

# case insensitive and allow
# substituted by the `_approximate` completer above
## zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'

# instead of showing "zsh: do you wish to see all the possiblities?", immediately list
zstyle ':completion:*' list-prompt  ''

# show prompt at the bottom during menu selection, if the list overflow the screen
zstyle ':completion:*' select-prompt ''

# emphasize the first ambiguous character
zstyle ':completion:*' show-ambiguity '1;34'

# display group descriptions
# https://github.com/Phantas0s/.dotfiles/blob/c01b080688c5e00d7b34529fc45dd46fe581275d/zsh/completion.zsh#L80-L83
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{cyan}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'

# don't group matches
zstyle ':completion:*' group-name ''

# make zsh understand docker option-stacking
# TODO try to add group name for docker completion somedays
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# tagged with `alias` will appear first
zstyle ':completion:*:*:-command-:*' group-order aliases builtins functions commands

# https://github.com/ohmyzsh/ohmyzsh/blob/8b2ce98578da743fbc4a208285f33744d6abd3cf/lib/completion.zsh#L47-L56
# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

# use cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$ZDOTDIR/.zcompcache"

# setup new key bindings to navigate in menu selection
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'n' accept-and-infer-next-history # accept and trigger next completion
bindkey -M menuselect '^xi' vi-insert # C-x i: toggle interactive mode
bindkey -M menuselect "${terminfo[kcbt]}" reverse-menu-complete # back-tap: select previous

# scoll down one line
bindkey -M listscroll '^n' down-line-or-history

autoload -Uz compinit && compinit

# also show hidden files
## _comp_options+=(globdots)

#################### ZSH plugins ###########################

# brew install starship
eval "$(starship init zsh)" # starship theme

plugins=(
    tmux
    git
    orb
    zsh-syntax-highlighting
    zsh-autosuggestions
)

if [ -z "$DEBUG_ZSH" ]; then
    ZSH_TMUX_AUTOCONNECT=false # never try to connect to previous session
    ZSH_TMUX_FIXTERM=false
    ZSH_TMUX_CONFIG="$XDG_CONFIG_HOME/tmux/tmux.conf"

    for plugin ($plugins); do
        load_plugin "$plugin"
    done
    unset plugin plugins
fi

