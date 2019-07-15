#set -x

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias hex_little_endian='vim -c ":%!xxd -e" $@'
alias edit_bash_history='vim -c ":$" ~/.bash_history'
alias git_log_custom='~/Documents/scripts/git_log_custom.sh'


sh_functions_file=~/.sh_functions 
[[ ! -f "$sh_functions_file" ]] && ~/Documents/scripts/generate_sh_functions_based_on_fish_shell_functions.sh
source "$sh_functions_file"

export PURPLE='\033[1;35m'
export ORANGE='\033[0;33m'
export CYAN='\033[1;36m'
export RED='\033[1;31m'
export YELLOW='\033[1;33m'
export GREEN='\033[1;32m'
export LIGHT_GREEN='\033[0;32m'
export NC='\033[0m'

# kubernetes autocompletion
source <(kubectl completion bash)

# kubernetes aliases
alias kb=kubectl
alias kbg="kubectl get"
alias kc=kubectl
alias kcg="kubectl get"
alias kn="kubens"
alias kbD="kubectl delete"
alias kba="kubectl apply"
alias kctx="kubectx"
alias kx="kubectx"
alias ktx="kubectx"


# auotmatically add all config files as a colon delimited string in KUBECONFIG
unset KUBECONFIG
for file in ~/.kube/* ; do
  if [ "$(basename $file)" == "kubectx" ]; then
    echo 1>/dev/null
  elif [ -f $file ]; then
    export KUBECONFIG=$KUBECONFIG:$file
  fi
done


# PATH
export PATH="$PATH":$HOME/.krew/bin

# configure to use direnv
eval "$(direnv hook bash 2>/dev/null || true)"

# make bash history saving immediate and shared between sessions
# taken from https://askubuntu.com/a/115625
# 
# history -c clears the history of the running session. This will reduce the history counter by the amount of $HISTSIZE. 
# history -r read the contents of $HISTFILE and insert them in to the current running session history.
# This will raise the history counter by the amount of lines in $HISTFILE
shopt -s histappend                      # append to history, don't overwrite it
export HISTFILESIZE=300000
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# ---------------------------
# prompt style start
tmux_id ()
{
  tmux list-pane | grep active | cut -d ']' -f3 | cut -d ' ' -f2
}

set_kubernetes_vars ()
{
   context="$(kubectl config current-context)"
   namespace="$(kubectl config view | grep -A 100 "$(kubectl config current-context | sed 's#.*@##')" | grep namespace | head -n1 |  sed 's#.*namespace: ##')"

   minikube_running="$(ps -ef | grep -v grep | grep minikube)"
   minikube_configured="$(kubectl config current-context | grep minikube)"
}

show_kubernetes_context ()
{
  set_kubernetes_vars

  local output="($context)  "

  if [ -z "$minikube_configured" ]; then
    echo -n "$output"
  else
    if [ ! -z "$minikube_running" ]; then
      echo -n "$output"
    fi
  fi
  
}

show_kubernetes_namespace ()
{
  set_kubernetes_vars

  local output=">$namespace< "

  if [ -z "$minikube_configured" ]; then
    echo -n "$output"
  else
    if [ ! -z "$minikube_running" ]; then
      echo -n "$output"
    fi
  fi
}

parse_git_branch() 
{
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/'
}

# enable __git_ps1 command
source /usr/share/git/completion/git-prompt.sh  # installed with git
# settings for __git_ps1
export GIT_PS1_SHOWDIRTYSTATE=1  # + for staged, * if unstaged.
export GIT_PS1_SHOWUNTRACKEDFILES=1  #  % if there are untracked files.
export GIT_PS1_SHOWUPSTREAM='verbose'  # 'u='=no difference, 'u+1'=ahead by 1 commit 

# !! remember to ecaspe dollar sign, otherwise PS1 caches the output !!
export PS1="[ \$(tmux_id) |  $LIGHT_GREEN\w$NC$PURPLE\$(__git_ps1)$NC \
\$(show_kubernetes_context)$YELLOW\$(show_kubernetes_namespace)$NC]\n$ "

# prompt style end
# --------------------------

