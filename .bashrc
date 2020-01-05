#set -x

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
if [[ -z "$TMUX" ]]; then
  if ! tmux list-sessions 2>/dev/null; then
    tmux -2 -u new 'sleep 4; tmux detach'
  else
    tmux -2 -u new  # -u -> utf-8; -2 -> force 256 colors
  fi 
fi

# ----
# keybindings | bind settings | binding settings

# set fish <CTRL+W> behavior; pressing <CTRL+W> deletes until next '/' for filenames
stty werase undef
bind '\C-w:unix-filename-rubout'

#
# ----


alias ls='ls --color=auto'
alias grep='grep --color'


# configure to use direnv
eval "$(direnv hook bash 2>/dev/null || true)"

source ~/Documents/scripts/source-me_posix-compliant-shells.sh
source ~/Documents/scripts/source-me_bash_passwd_script_autocompletion.sh

# -----
# kubectl | kubernetes  just bash
#

# kubernetes autocompletion | kubectl autocompletion
[[ -x kubectl ]] && tsource <(kubectl completion bash)

# helper functions such as 'get_pod' for kubernetes
source ~/Documents/scripts/kubernetes/source-me_common_functions.sh
#------------



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

xrdb -merge ~/.Xdefaults

