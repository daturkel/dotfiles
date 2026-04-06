export ZSH=$HOME/.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# enable p10k
source ~/.powerlevel10k/powerlevel10k.zsh-theme

# ── Environment ───────────────────────────────────────────────────────────────

export PATH=$PATH:$zsh_path
export EDITOR="/opt/homebrew/bin/nvim"
export VISUAL="/opt/homebrew/bin/nvim"
export GOPATH=$HOME/go
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/

# ── History ───────────────────────────────────────────────────────────────────

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
HISTORY_IGNORE="(ls|cd|pwd|exit)*"
HIST_STAMPS="yyyy-mm-dd"
setopt INC_APPEND_HISTORY_TIME  # write time taken to history after command finishes
setopt HIST_IGNORE_DUPS         # do not record an event that was just recorded again
setopt HIST_IGNORE_ALL_DUPS     # delete old event if new event is a duplicate
setopt HIST_SAVE_NO_DUPS        # do not write a duplicate event to the history file
setopt HIST_VERIFY              # do not execute immediately upon history expansion
setopt HIST_NO_STORE            # don't store history commands
setopt HIST_REDUCE_BLANKS       # remove superfluous blanks from each command line
setopt transient_rprompt        # remove the right prompt from anything other than current line

# ── Completion ────────────────────────────────────────────────────────────────

# uv - completions cached to avoid subprocess cost on every startup
if [[ ! -f ~/.cache/zsh/completions/_uv ]]; then
  mkdir -p ~/.cache/zsh/completions
  uv generate-shell-completion zsh > ~/.cache/zsh/completions/_uv
  uvx --generate-shell-completion zsh > ~/.cache/zsh/completions/_uvx
fi
fpath=(~/.cache/zsh/completions $fpath)

# -C skips compaudit security check (saves ~15ms); run compinit without -C occasionally to recheck
autoload -U compinit; compinit -C
_comp_options+=(globdots)  # include hidden files
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case insensitive matching
zstyle ':completion:*' menu select

# ── Keybindings ───────────────────────────────────────────────────────────────

# vi mode
export KEYTIMEOUT=1  # faster mode transition

# up/down arrows: history search in all vi modes
bindkey "$terminfo[kcuu1]" history-beginning-search-backward
bindkey "$terminfo[kcud1]" history-beginning-search-forward
bindkey -M vicmd "$terminfo[kcuu1]" history-beginning-search-backward
bindkey -M vicmd "$terminfo[kcud1]" history-beginning-search-forward
bindkey -M viins "$terminfo[kcuu1]" history-beginning-search-backward
bindkey -M viins "$terminfo[kcud1]" history-beginning-search-forward

# history search with end-of-line positioning
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end

# edit command in editor
autoload -z edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# ── FZF ───────────────────────────────────────────────────────────────────────

# ctrl-t: files, alt-c: cd, ctrl-r: history
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND="rg --files 2> /dev/null"
export FZF_DEFAULT_OPTS="--style minimal --preview 'bat -p --color=always {}'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"
export FZF_CTRL_R_OPTS='--preview-window="hidden"'
bindkey -r '^G'
source ~/fzf-git.sh

# ctrl-l: live rg search, enter to insert filename, ctrl-e to open in editor
rg-fzf-widget() {
  local RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "

  local selected=$(
    fzf --ansi \
        --disabled \
        --bind "start:reload:$RG_PREFIX ''" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --bind "enter:accept" \
        --bind "ctrl-e:execute($EDITOR {1} +{2})+abort" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'right:60%:+{2}+3/3' \
        --header 'Enter: insert | Ctrl-E: edit'
  )

  if [[ -n "$selected" ]]; then
    LBUFFER="${LBUFFER}$(echo "$selected" | cut -d: -f1)"
  fi

  zle redisplay
}
zle -N rg-fzf-widget
bindkey '^l' rg-fzf-widget

# ── Functions ─────────────────────────────────────────────────────────────────

# git diff between two refs (tags, branches, etc.) with optional path
gd() {
  git diff "$1" "$2" -- "${3:-.}"
}
_gd() {
  local refs=($(git tag 2>/dev/null) main master)
  _arguments \
    '1:from ref:($refs)' \
    '2:to ref:($refs)' \
    '3:path:_files'
}
compdef _gd gd

# ctrl-p: rg through claude plan files with fzf
plans-search() {
  local PLANS_DIR="$HOME/.claude/plans"
  local RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "

  local selected=$(
    fzf --ansi \
        --disabled \
        --bind "start:reload:$RG_PREFIX '' $PLANS_DIR --sortr modified | sed \"s|$PLANS_DIR/||\"" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} $PLANS_DIR --sortr modified | sed \"s|$PLANS_DIR/||\" || true" \
        --bind "enter:accept" \
        --bind "ctrl-e:execute($EDITOR $PLANS_DIR/{1} +{2})+abort" \
        --delimiter : \
        --preview "bat -p --color=always $PLANS_DIR/{1} --highlight-line {2}" \
        --preview-window 'down:60%:+{2}+3/3' \
        --header 'Enter: insert path | Ctrl-E: open in editor'
  )

  if [[ -n "$selected" ]]; then
    LBUFFER="${LBUFFER}$PLANS_DIR/$(echo "$selected" | cut -d: -f1)"
  fi

  zle redisplay
}
zle -N plans-search
bindkey -r '^p'
bindkey '^p' plans-search

# alt-p: browse claude plan files by filename with fzf
plans-title() {
  local PLANS_DIR="$HOME/.claude/plans"

  local selected=$(
    ls -t "$PLANS_DIR" | fzf \
        --preview "bat -p --color=always $PLANS_DIR/{}" \
        --preview-window 'down:60%' \
        --header 'Enter: insert path | Ctrl-E: open in editor' \
        --bind "ctrl-e:execute($EDITOR $PLANS_DIR/{})+abort"
  )

  if [[ -n "$selected" ]]; then
    LBUFFER="${LBUFFER}$PLANS_DIR/$selected"
  fi

  zle redisplay
}
zle -N plans-title
bindkey '^[p' plans-title

# ── Aliases ───────────────────────────────────────────────────────────────────

alias cheatsheet='cat <<EOF
FZF
  ctrl-t    files
  alt-c     cd
  ctrl-r    history
  ctrl-l    live rg search (enter: insert, ctrl-e: edit)
  ctrl-p    search claude plans by content
  alt-p     search claude plans by filename

Git
  gst       git status
  ga        git add
  gc        git checkout
  gs        git switch
  gl        git log --oneline
  gd        diff between two refs: gd <from> <to> [path]
  cr        cd to repo root
EOF
'

alias vim='nvim'
alias mkdir='mkdir -pv'
alias reload='source ~/.zshrc'
alias plans='cd ~/.claude/plans'
alias cr='cd $(git rev-parse --show-toplevel)'

# git
alias gst='git status'
alias ga='git add'
alias gc='git checkout'
alias gs='git switch'
alias gl='git log --oneline'

# python venvs
alias v='source ./.venv/bin/activate'
alias vv='source ~/.venv/bin/activate'

$aliases

# ── Prompt ────────────────────────────────────────────────────────────────────

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ -f ~/.secrets ]] && source ~/.secrets
