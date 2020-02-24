# Path to your oh-my-zsh installation.
export ZSH=${home_dir}.oh-my-zsh

export EDITOR="/usr/local/bin/nvim"

export BROWSER="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="uncommon"

# Change behavior of up arrow
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT=true

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(vi-mode colorize shrink-path ripgrep poetry)

# make vi mode transition faster
export KEYTIMEOUT=1
# maintain behavior of up and down arrows in vim-mode
bindkey "$terminfo[kcuu1]" history-beginning-search-backward
bindkey "$terminfo[kcud1]" history-beginning-search-forward
bindkey -M vicmd "$terminfo[kcuu1]" history-beginning-search-backward
bindkey -M vicmd "$terminfo[kcud1]" history-beginning-search-forward
bindkey -M viins "$terminfo[kcuu1]" history-beginning-search-backward
bindkey -M viins "$terminfo[kcud1]" history-beginning-search-forward

# User configuration

export PATH=$zsh_path
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x88_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias vim='nvim'
alias gd='git diff --name-status master... | cat'
alias s='git status'
alias v='source venv/bin/activate'
alias cr='cd $(git rev-parse --show-toplevel)'
alias d='cd ~/Notes'
alias g='cd ~/Dropbox\ \(Personal\)/Grad\ School'
$aliases

function gline() {
    if [ "$1" != "" ]
    then
        grep -ril "$1" . | grep -v ':0$'
    else
        echo 'error: please supply pattern argument'
    fi
}

## FZF commands
# ctrl-t: files, but just completes filename, doesn't open
# ctrl-o: search file lines, open editor
# ctrl-s: CD
# ctrl-r: zsh history
# ctrl-n: notational fzf

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND="rg --files 2> /dev/null"

export FZF_DEFAULT_OPTS="--preview '[[ \$(file --mime {}) = binary ]] &&
    echo {} is a binary file ||
    (bat --color=always {} ||
    cat {}) 2> /dev/null | head -500'"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"

fzf_grep_edit(){
    local match=$(
      rg --color=never --line-number "" |
        fzf --no-multi --delimiter : \
            --preview "bat --color=always --line-range {2}: {1}"
      )
    local file=$(echo "$match" | cut -d':' -f1)
    if [[ -n $file ]]; then
        $EDITOR $file +$(echo "$match" | cut -d':' -f2)
    fi
}

zle -N fzf_grep_edit
bindkey "^o" fzf_grep_edit

bindkey "^s" fzf-cd-widget

vim_nv() vim -c NV!
zle -N vim_nv

bindkey "^n" vim_nv

export FZF_CTRL_R_OPTS='--preview-window="hidden"'

ts(){
    vim $(awk 'FNR==3 {print FILENAME, "|", $0}' ~/Notes/*.md |
        fzf -d '\|' --preview='bat {1}' |
        awk '{print $1;}')
}

$misc_exports

# don't share history between panes
unsetopt inc_append_history
unsetopt share_history

# temp fix while bat is broken
# https://github.com/sharkdp/bat/issues/509
export BAT_PAGER="less -FR"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
