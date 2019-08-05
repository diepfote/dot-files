#set -x

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color'


# configure to use direnv
eval "$(direnv hook bash 2>/dev/null || true)"

source ~/Documents/scripts/source-me_posix-compliant-shells.sh

# kubernetes autocompletion
source <(kubectl completion bash)




# make bash history saving immediate and shared between sessions
# taken from https://askubuntu.com/a/115625
# 
# history -c clears the history of the running session. This will reduce the history counter by the amount of $HISTSIZE. 
# history -r read the contents of $HISTFILE and insert them in to the current running session history.
# This will raise the history counter by the amount of lines in $HISTFILE
shopt -s histappend                      # append to history, don't overwrite it
export HISTSIZE=300000
export HISTFILESIZE=300000
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"


# --------------------------
# prompt style start
#

# !! remember to ecaspe dollar signs, otherwise PS1 caches the output !!
#source ~/Documents/scripts/source-me_prompt-style.sh
#source ~/Documents/scripts/tmux_info.sh

#export PS1="[ \$(tmux_id) |  $LIGHT_GREEN\w$NC$PURPLE\$(__git_ps1)$NC \
#\$(show_kubernetes_context)$YELLOW\$(show_kubernetes_namespace)$NC]\n$ "


export PS1="[ $LIGHT_GREEN\w$NC$PURPLE\$(__git_ps1)$NC${YELLOW} \$(show_openstack_project)$RED\$?$NC ]\n$ " 

#
# prompt style end
# --------------------------

