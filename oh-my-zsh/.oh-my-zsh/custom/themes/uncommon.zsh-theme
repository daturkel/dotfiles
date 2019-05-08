# vim: filetype=sh

# heavily modified version of common.zsh-theme

# Prompt symbol
UNCOMMON_PROMPT_SYMBOL="%{$fg[green]%}$%f"

# Left Prompt
PROMPT='$(uncommon_host)$(uncommon_current_dir)$(uncommon_git_venv)$UNCOMMON_PROMPT_SYMBOL '

# Host
uncommon_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    me="%n@%m"
  elif [[ $LOGNAME != $USER ]]; then
    me="%n"
  fi
  if [[ -n $me ]]; then
    echo "%{$fg[green]%}$me%{$reset_color%}:"
  fi
  if [[ $AWS_VAULT ]]; then
    echo "%{$fg[yellow]%}$AWS_VAULT%{$reset_color%} "
  fi
}

# Current directory
uncommon_current_dir() {
    echo -n "%{$fg[cyan]%}$(shrink_path -f) %f"
}

# Git status
uncommon_git_status() {
    local message=""
    local suffix=""

    local staged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU]")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU? ][MADRCU?]")

    if [[ (-n ${staged}) && (-n ${unstaged}) ]]; then
        suffix=";"
    elif [[ -n ${staged} ]]; then
    	suffix="·"
    elif [[ -n ${unstaged} ]]; then
    	suffix=","
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n ${branch} ]]; then
        message+="%{$fg[yellow]%}${branch}${suffix}%f"
    fi
    echo -n "${message}"
}

# Virtualenv
# disable prompt mangling in virtual_env/bin/activate script
export VIRTUAL_ENV_DISABLE_PROMPT=1
uncommon_venv() {
    local message=""
    if [[ -n ${VIRTUAL_ENV} ]]; then
        [[ ${VIRTUAL_ENV} =~ '[^\/]*$' ]]
        message="%{$fg[yellow]%}${MATCH}%f"
    fi
    export CV="${message}"
    echo -n "${message}"
}

uncommon_git_venv() {
    #local prefix="%{$fg[yellow]%}"
    local message=""
    if [[ (-n "$(uncommon_venv)") && (-n "$(uncommon_git_status)") ]]; then
        message="$(uncommon_venv)|$(uncommon_git_status) "
    elif [[ -n "$(uncommon_venv)" ]]; then
        message="$(uncommon_venv)| "
    elif [[ -n "$(uncommon_git_status)" ]]; then
        message="|$(uncommon_git_status) "
    else
        message=""
    fi

    echo -n "${message}"
}
