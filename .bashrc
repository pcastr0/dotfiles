# SOURCE GLOBAL DEFINITIONS
#
if [ -f /usr/bin/fastfetch ]; then
	fastfetch
fi

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init bash)"
fi

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# PROMPT
# 
function parse_git_dirty {
  [[ $(git status --porcelain 2> /dev/null) ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(parse_git_dirty))/"
}

export PS1="\t \[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

# EXPORTS
# Expand the history size
export HISTFILESIZE=100000
export HISTSIZE=500
export HISTTIMEFORMAT="%F %T"

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ingoredups:ingorespace

# Check the window size after each command and, if necessary, update the value of LINES and COLUMNS
shopt -s checkwinsize

# Causes bash to append to history instead of overwriting it so if you start a terminal, you have a old session history
shopt -s histappend
PROMPT_COMMAND='history -a'

# set up XDG folders
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Allow ctrl-S for history navigation (with ctrl-R)
#[[ $- == *i* ]] && stty -ixon

# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest -gt 0 ]]; then bind "set completion-ignore-case on"; fi

# Show auto-completion list automatically, without double tab
if [[ $iatest -gt 0 ]]; then bind "set show-all-if-ambiguous On"; fi

# Set the default editor
export EDITOR=nvim
export VISUAL=nvim
alias snano='sudo nano'
alias svim='sudo vim'
alias svi='sudo vi'
alias vim='nvim'

# ALIASES
# 
alias cat='bat'

alias rm='trash -v'

alias home='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias ll='ls -l'
alias lsa='ls -la'
alias lsf='ls -F'
#

# FUNCTIONS
# do an ls after a cd
cd () {
    
    if [ -n "$1" ]; then
	builtin cd "$@" && ls
    else
	builtin cd ~ && ls
    fi
    }
#

