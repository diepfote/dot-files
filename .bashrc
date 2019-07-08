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

export RED='\033[1;31m'
export YELLOW='\033[1;33m'
export GREEN='\033[1;32m'
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
   context="$(kubectl config current-context 2>/dev/null || true )"
   namespace="$(kubectl config view | grep -A 100 "$(kubectl config current-context 2>/dev/null || true  | sed 's#.*@##')" | grep namespace | sed 's#.*namespace: ##')"

   minikube_running="$(ps -ef | grep -v grep | grep minikube)"
   minikube_configured="$(kubectl config current-context 2>/dev/null || true | grep minikube)"
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

# !! remember to ecaspe dollar sign, otherwise PS1 caches the output !!
export PS1="[ \$(tmux_id) |  \W\[\033[32m\] \$(parse_git_branch)\[\033[00m\] \
\$(show_kubernetes_context)\033[1;33m\$(show_kubernetes_namespace)\033[0m]\n$ "

# prompt style end
# --------------------------

