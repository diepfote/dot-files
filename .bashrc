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

# minikube config
export KUBECONFIG=$HOME/.kube/minikube

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
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# prompt style start
tmux_id () {
  tmux list-pane | grep active | cut -d ']' -f3 | cut -d ' ' -f2
}

parse_git_branch() {
      git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/'
}
export PS1="[ $(tmux_id) | \u@\h \W\[\033[32m\] \$(parse_git_branch)\[\033[00m\] >$(env | grep KUBECONFIG | cut -d '/' -f5)< ] $ "

# prompt style end
