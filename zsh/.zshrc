export ZSH=$HOME/.zsh

# Path
export PATH=$PATH:$zsh_path
# export PATH=$PATH:~/.cargo/bin
# export PATH=$PATH:~/go/bin

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# enable p10k
source ~/.powerlevel10k/powerlevel10k.zsh-theme

# make vi mode transition faster
export KEYTIMEOUT=1
# maintain behavior of up and down arrows in vim-mode
bindkey "$terminfo[kcuu1]" history-beginning-search-backward
bindkey "$terminfo[kcud1]" history-beginning-search-forward
bindkey -M vicmd "$terminfo[kcuu1]" history-beginning-search-backward
bindkey -M vicmd "$terminfo[kcud1]" history-beginning-search-forward
bindkey -M viins "$terminfo[kcuu1]" history-beginning-search-backward
bindkey -M viins "$terminfo[kcud1]" history-beginning-search-forward

export EDITOR="/usr/local/bin/nvim"
export VISUAL="/usr/local/bin/nvim"

# edit commands in editor
autoload -z edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# case insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# history
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end
HISTFILE="$ZSH/.zsh_history"     # History filepath
HISTSIZE=10000000
SAVEHIST=10000000
HISTORY_IGNORE="(ls|cd|pwd|exit|cd)*"
HIST_STAMPS="yyyy-mm-dd"
setopt EXTENDED_HISTORY      # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY    # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY         # Share history between all sessions.
setopt HIST_IGNORE_DUPS      # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS  # Delete an old recorded event if a new event is a duplicate.
setopt HIST_SAVE_NO_DUPS     # Do not write a duplicate event to the history file.
setopt HIST_VERIFY           # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY        # append to history file (Default)
setopt HIST_NO_STORE         # Don't store history commands
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from each command line being added to the history.

# completion
autoload -U compinit; compinit
_comp_options+=(globdots) # With hidden files

# FZF
# ctrl-t: files, but just completes filename, doesn't open
# ctrl-o: search file lines, open editor
# ctrl-s: CD
# ctrl-r: zsh history
# ctrl-w: wiki
source <(fzf --zsh)
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

# Haskell
[ -f "/Users/danturkel/.ghcup/env" ] && source "/Users/danturkel/.ghcup/env" # ghcup-env

# OpenSSL
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/

# Aliases
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


# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# go
export GOPATH=$HOME/go

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
