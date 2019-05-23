# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias hex_little_endian='nvim -c ":%!xxd -e" $@'

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

