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
# 7. Any UI-related scripts should be loaded immediately; other scripts can be deferred with __try_defer.
#

if [[ ! -d $ZDOTDIR ]]; then
    echo "refuse to load .zshrc since ZDOTDIR is invalid" >&2
    return 1
fi

# See https://www.emacswiki.org/emacs/TrampMode Tramp hangs #3
[[ "$TERM" == "dumb" ]] && unsetopt zle && PS1="$ " && return

#################### Function Utils ########################

if [[ -s "$ZDOTDIR/.zsh-plugins/zsh-defer/zsh-defer" ]]; then
    autoload -Uz $ZDOTDIR/.zsh-plugins/zsh-defer/zsh-defer
    __try_defer() {
        zsh-defer "$@"
    }
else
    print -u2 "zsh: cannot autoload zsh-defer function, the shell setup may be incomplete"
    __try_defer() {
        builtin eval "$@"
    }
fi

__load_plugin() {
    emulate -L zsh

    local plugin
    local defer=1

    while (( $# )); do
        case $1 in
            --no-defer)
                defer=0
                ;;
            *)
                plugin="$1"; break
                ;;
        esac
        shift
    done

    if [[ -s "$ZDOTDIR/.zsh-plugins/$plugin/$plugin.plugin.zsh" ]]; then
        if [[ $defer -eq 0 ]]; then
            source "$ZDOTDIR/.zsh-plugins/$plugin/$plugin.plugin.zsh"
        else
            __try_defer source "$ZDOTDIR/.zsh-plugins/$plugin/$plugin.plugin.zsh"
        fi
    else
        echo "zsh: cannnot load plugin $plugin"
    fi
}

################### General Configurations #################

# redirect shouldn't overwrite a existing file
setopt noclobber

# allow comments when interactive
setopt interactivecomments

# ^S/^Q has no effect on start/stop the flow
setopt noflowcontrol

# history
export HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTORY_IGNORE="(*${USER}*)"
## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data
alias history='fc -i -l 1'    # -i = timestamp

alias e="$EDITOR"

#################### Directory #############################

# if a directory is placed as "command", `cd` to it
setopt autocd

setopt auto_pushd # pushd_ignore_dups
for ((i=1;i<=9;i+=1)); do alias $i="cd +$i"; done; unset i

# generated via https://geoff.greer.fm/lscolors
# GNU ls (included in coreutils) color
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
# BSD ls color
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Enable colors when not piped
alias ls='ls --color=auto'

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

# select-word-style is a use-defined function that wraps word-chars and other
# settings to provide an easier interface to customize the ZLE word style.
autoload -U select-word-style
select-word-style bash

# bind emacs keymapping to main
bindkey -e

# precede the current command with `#` and then accept
bindkey -M emacs '^[#' pound-insert # M-#

# accept current command, and push it to the buffer again
[ -z "$INSIDE_EMACS" ] && bindkey -M emacs '^J' accept-and-hold

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

# list-choices: list possible completions for the current word.
bindkey -M emacs '^[?' list-choices

# duplicate bash alt-r (revert-line)
revert-line() {
    while zle .undo; do done
    zle .end-of-line
}
zle -N revert-line
bindkey '^[r' revert-line

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
if (( $+terminfo[kcbt] )); then
    bindkey -M menuselect "${terminfo[kcbt]}" reverse-menu-complete # back-tap: select previous
fi

# scoll down one line
bindkey -M listscroll '^n' down-line-or-history

# zsh-users/zsh-completions: additional completions
__load_plugin --no-defer zsh-completions

# also show hidden files
_comp_options+=(globdots)

#################### Platform-Dependent ####################

# On differenet operating systems, many things can vary:
#       package manager, system utilites, etc.
# Therefore we need to conditionally source other scripts in this section.

# Inputs:
# - __try_defer: a subroutine that will try to use `zsh-defer` to eval the command.

# Outputs:
# (For portability, these OS-dependent scripts should define some parameters for further use.)
# - FZF_SCRIPT_BASE: the fzf installation directory.
# - Provide more FPATH entries

case "$OSTYPE" in
    darwin*)
        builtin source "$ZDOTDIR/.zshrc-darwin"
        ;;
    linux*)
        builtin source "$ZDOTDIR/.zshrc-debian"
        ;;
    *)
        ;;
esac

#################### Shortcuts #############################

alias :q="exit"

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

# -i: prompt if need to overwrite an existing file
alias cp='cp -i'
alias mv='mv -i'

# Enable colors for grep
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# `-i`: smart case insensitive
## export MANPAGER="less -sRi"
export MANPAGER='nvim +Man!'

# git-repo
export REPO_URL='https://mirrors.tuna.tsinghua.edu.cn/git/git-repo'

# bat
export BAT_THEME="gruvbox-dark"

# trash-cli
alias rm='echo "This is not the command you are looking for."; false'

# nnn
alias n='n -Ae' # always open text files in the terminal
export NNN_PLUG="p:preview-tui;z:autojump;d:macos-trash"
export NNN_FIFO="/tmp/nnn.fifo"
export NNN_ZLUA="$ZDOTDIR/.zsh-plugins/z.lua/z.lua"

# fzf
# Setup completion, keybindings for fzf.
# The funtion is defered until completion system is inited.
# PARAMS: FZF_SCRIPT_BASE
__fzf_setup() {
    local script_base="$1"
    () {
        builtin emulate -L zsh -o err_return
        source "$script_base/completion.zsh"
        source "$script_base/key-bindings.zsh"
    } || {
        print -u2 "[fzf-setup] cannot source init scripts"
        return 1
    }
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

# fzf rebind TAB (^I), so it must be inited after `compinit` (defer it).
# zsh-defer can even defer the task when __fzf_setup isn't defined.
[[ -n "$FZF_SCRIPT_BASE" ]] && __try_defer __fzf_setup "$FZF_SCRIPT_BASE"

# z.lua data
export _ZL_DATA="${XDG_CONFIG_HOME:-$HOME/.config}/zlua/.zlua"

# register the previous command easily for pet
function prev() {
  PREV=$(builtin fc -lrn | head -n 1)
  sh -c "pet new -t `printf %q "$PREV"`"
}

# GNU Emacs
export PATH="$PATH:$XDG_CONFIG_HOME/emacs/bin"
alias emacs-client='tmux new-session -s "emacs-client" -d emacsclient -c -a emacs'
alias emacs-kill-server="emacsclient -e '(save-buffers-kill-emacs)'"
[ -n "$INSIDE_EMACS" ] && ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8,underline"


#################### Routines ##############################

# I recommend installing standalone pnpm (not using `npm install -g`).
# But pnpm is still dependent on nodejs.
# This routine set pnpm home and tab-completion.
alias pnpm="print -u2 'Please use \`loadpnpm\` first'; false"
loadpnpm() {
    # pnpm tabtab completions
    export PNPM_HOME="$XDG_DATA_HOME/pnpm"
    export PATH="$PNPM_HOME:$PATH"
    [[ -f "$XDG_CONFIG_HOME/tabtab/zsh/__tabtab.zsh" ]] && \
        \. "$XDG_CONFIG_HOME/tabtab/zsh/__tabtab.zsh"
    unalias pnpm 2>/dev/null || true
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

curl_github() {
    curl -sSLO "https://raw.githubusercontent.com/$1"
}

editz() {
    eval "$EDITOR" "$ZDOTDIR/.zshrc"
}

most-often-use() {
    fc -l 1 | \
    awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | \
    grep -vE '( \.)|/|\\' | \
    column -c3 -s " " -t | \
    sort -nr | nl |  head -n "$1"
}

#################### ZSH plugins ###########################

if (( $+commands[starship] )); then
    eval "$(starship init zsh)" # starship theme
else
    # https://dev.to/cassidoo/customizing-my-zsh-prompt-3417
    setopt PROMPT_SUBST
    PROMPT='%F{green}%*%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '
fi

# plugins that have no deps
plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
)

# plugins that are installed only when the deps are available
# [key, value] = [plugin, dep]
# TODO: multiple deps
typeset -A __plugin_dep
__plugin_dep=(
    tmux tmux
    orb orb
    nnn-quitcd nnn
    z.lua lua
)

() {
    for plugin ("${(k)__plugin_dep[@]}"); do
        (( $+commands[${__plugin_dep[$plugin]}] )) && plugins=($plugin $plugins)
    done
    ZSH_TMUX_AUTOCONNECT=false # never try to connect to previous session
    ZSH_TMUX_FIXTERM=false
    ZSH_TMUX_CONFIG="$XDG_CONFIG_HOME/tmux/tmux.conf"
    _ZL_NO_ALIASES=1

    for plugin ($plugins); do
        __load_plugin "$plugin"
    done
    unset plugin plugins
}

#################### Final Initialization ##################

autoload -Uz compinit && compinit
