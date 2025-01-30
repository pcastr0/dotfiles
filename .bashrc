## SOURCE GLOBAL DEFINITIONS

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

if [ -f /usr/bin/fastfetch ]; then
    fastfetch
fi

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init bash)"
fi

if command -v mise &> /dev/null; then
  eval "$(mise activate bash)"
fi


# History control
shopt -s histappend
shopt -s checkwinsize
HISTCONTROL=erasedups:ignoredups:ignorespace
HISTSIZE=32768
HISTFILESIZE="${HISTSIZE}"
HISTTIMEFORMAT="%F %T"

# Set complete path
#
export PATH="./bin:$HOME/.local/bin:$HOME/bin:$PATH"
set +h

## PROMPT
function parse_git_dirty {
    [[ $(git status --porcelain 2>/dev/null) ]] && echo "*"
}
function parse_git_branch {
    git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(parse_git_dirty))/"
}

#export PS1="\[\033[32m\]\t\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

export PS1="\[$(tput setaf 154)\]\@\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

# Set default editor
export EDITOR=nvim
export VISUAL=nvim
alias svim='sudo vim'
alias vim='nvim'


## ALIASES
# File system
alias ls='eza --group-directories-first --icons'
alias ll='eza -lh --group-directories-first --icons'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'batcat --style=numbers --color=always {}'"
alias fd='fdfind'
#alias rm='trash -v'

# Directories
alias home='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
alias bat='bat'
alias lzg='lazygit'
alias lzd='lazydocker'

# Git
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

## FUNCTIONS
# Automatically do an ls after each cd, z, or zoxide
cd () {
    if command -v zoxide &>/dev/null; then
        # echo "Using zoxide for cd: $*"
        z "$@" && ls || echo "Failed to change directory with zoxide"
    else
        # echo "Using builtin cd: $*"
        builtin cd "$@" && ls || echo "Failed to change directory with builtin cd"
    fi
}
