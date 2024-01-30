# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# # Path to your oh-my-zsh installation.
export ZSH=${home_dir}.oh-my-zsh

# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_UPDATE_PROMPT=true
# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(shrink-path)

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
# Change behavior of up arrow
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
# Other useful env vars
export EDITOR="/usr/local/bin/nvim"
export PATH=$zsh_path
export PATH=$PATH:~/.cargo/bin
export PATH=$PATH:~/go/bin
# Haskell
[ -f "/Users/danturkel/.ghcup/env" ] && source "/Users/danturkel/.ghcup/env" # ghcup-env
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/
source $ZSH/oh-my-zsh.sh

alias vim='nvim'
alias cr='cd $(git rev-parse --show-toplevel)'
# make directories including parents
alias mkdir='mkdir -pv'
alias gs='git status'
alias ga='git add'
alias gc='git checkout'
alias gl='git log --oneline'
alias gpo='git push origin'
alias ci='code-insiders'
$aliases

## FZF commands
# ctrl-t: files, but just completes filename, doesn't open
# ctrl-o: search file lines, open editor
# ctrl-s: CD
# ctrl-r: zsh history
# ctrl-w: wiki
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

export FZF_CTRL_R_OPTS='--preview-window="hidden"'

$misc_exports

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export GOPATH=$HOME/go

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
