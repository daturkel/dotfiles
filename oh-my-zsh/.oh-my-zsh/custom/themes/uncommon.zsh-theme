# vim: filetype=zsh

# uncommon is a fork of common, a theme by jack harrison-sherlock
# check out the original at https://github.com/jackharrisonsherlock/common

### FINAL PROMPT
## configure by reordering functions
PROMPT='$(uncommon_host)$(uncommon_git_venv)$(uncommon_current_dir)$(uncommon_symbol) '

### PROMPT SYMBOL
## configure by changing variables
uncommon_symbol() {
    # what symbol to show for default prompt
    local sym_unpriv="$"
    local col_unpriv="green"

    local unpriv="%{$fg[$col_unpriv]%}$sym_unpriv%{$reset_color%}"

    # what symbol to show for root/superuser prompt
    local sym_priv="#"
    local col_priv="red"

    local priv="%{$fg[$col_priv]%}$sym_priv%{$reset_color%}"
    # prompt symbol
    local symbol="%(!.${priv}.${unpriv})"

    echo -n "$symbol"
}


### HOST
## retained from original common theme
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

### CURRENT DIRECTORY
## configure by changing variable, commenting/uncommenting
uncommon_current_dir() {
    local col_cd="cyan"

    # option 1
    # ~/john/Documents/test -> ~/j/D/test
    # you must have oh-my-zsh and enable the plugin "shrink_path"
    echo -n "%{$fg[$col_cd]%}$(shrink_path -f)%{$reset_color%} "

    # option 2
    # ~/john/Documents/test -> test
    #echo -n "%{$fg[$col_cd]%}%1~$reset_color "

    # option 3
    # ~/john/Documents/test (full path)
    #echo -n "%{$fg[$col_cd]%}%~$reset_color "

}

### GIT STATUS
## configure by changing variables
uncommon_git_status() {
    ## change these
    # symbol if there are staged AND unstaged changes
    local sym_su=";"
    # symbol if there are staged changes only
    local sym_s="."
    # symbol if there are unstaged changes only
    local sym_u=","

    ## don't change these
    local message=""
    local suffix=""
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    local staged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU]")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU? ][MADRCU?]")

    if [[ (-n $staged) && (-n $unstaged) ]]; then
        suffix="${sym_su}"
    elif [[ -n $staged ]]; then
    	suffix="${sym_s}"
    elif [[ -n $unstaged ]]; then
    	suffix="${sym_u}"
    fi

    if [[ -n ${branch} ]]; then
        message="${branch}${suffix}"
    else
        message=""
    fi
    echo -n "${message}"
}

### PYTHON VIRTUALENV
## not currently configurable
# (this line disables built-in prompt manipulation in virtual_env/bin/activate scripts)
export VIRTUAL_ENV_DISABLE_PROMPT=1
# if you are using anaconda for your environments, run "conda config --set changeps1 False"
# or add "changeps1: False" to your .condarc file
uncommon_venv() {
    local message=""
    if [[ -n ${VIRTUAL_ENV} ]]; then
        [[ ${VIRTUAL_ENV} =~ '[^\/]*$' ]]
        message="${MATCH}"
    elif [[ -n $CONDA_DEFAULT_ENV ]]; then
        message="${CONDA_DEFAULT_ENV}"
    fi
    export CV="${message}"
    echo -n "${message}"
}

uncommon_git_venv() {
    ## change these
    # if we're not in a git repo or don't have a virtualenv, show this symbol
    local sym_empty="•"
    # what color should this part be
    local col_gv="yellow"

    ## don't change this
    local message=""
    if [[ (-n "$(uncommon_venv)") && (-n "$(uncommon_git_status)") ]]; then
        message="[$(uncommon_venv)|$(uncommon_git_status)] "
    elif [[ -n "$(uncommon_venv)" ]]; then
        message="[$(uncommon_venv)|$sym_empty] "
    elif [[ -n "$(uncommon_git_status)" ]]; then
        message="[$sym_empty|$(uncommon_git_status)] "
    else
        message=""
    fi

    echo -n "%{$fg[$col_gv]%}${message}%f"
}
