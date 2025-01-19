# SOURCE GLOBAL DEFINITIONS
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if command -v mise &> /dev/null; then
  eval "$(mise activate bash)"
fi

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init bash)"
fi

if [ -f /usr/bin/fastfetch ]; then
    fastfetch
fi


# User-specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment if you dislike systemctl's auto-paging:
# export SYSTEMD_PAGER=

# Source additional user scripts
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        [ -f "$rc" ] && . "$rc"
    done
fi
unset rc

# PROMPT
function parse_git_dirty {
    [[ $(git status --porcelain 2>/dev/null) ]] && echo "*"
}
function parse_git_branch {
    git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(parse_git_dirty))/"
}
export PS1="\t \[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

# EXPORTS
#export HISTFILESIZE=100000
#export HISTSIZE=500
#export HISTTIMEFORMAT="%F %T"
#export HISTCONTROL=erasedups:ignoredups:ignorespace
#shopt -s checkwinsize histappend
# PROMPT_COMMAND='history -a'

# XDG folders
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Auto-completion tweaks
#if [[ $- == *i* ]]; then
#    bind "set completion-ignore-case on"
#    bind "set show-all-if-ambiguous on"
#fi

# Set default editor
export EDITOR=nvim
export VISUAL=nvim
alias snano='sudo nano'
alias svim='sudo vim'
alias nv='nvim'

# ALIASES
if command -v bat &>/dev/null; then
    alias cat='bat'
fi
if command -v trash &>/dev/null; then
    alias rm='trash -v'
fi

alias home='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
# Listing directories
alias ll='ls -l'
alias lt='tree -L 2 -F'
alias lsa='ls -la'
alias lsf='ls -F'

# Automatically do an ls after each cd, z, or zoxide
cd () {
    if [ -n "$1" ]; then
        builtin cd "$@" && ls -l
    else
        builtin cd ~ && ls -l
    fi
}
