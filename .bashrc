#set -x

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# If on podman-remote, return immediately
[ "$(uname)" = podman-remote ] && return


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


# configure to use direnv
eval "$(direnv hook bash 2>/dev/null || true)"

source ~/Documents/scripts/source-me_posix-compliant-shells.sh

# -----
# kubectl | kubernetes  just bash
#

# kubernetes autocompletion | kubectl autocompletion
[[ -x kubectl ]] && tsource <(kubectl completion bash)

# Darwin
if [ "$(uname)" = Darwin ]; then
  dir=/usr/local/etc/bash_completion.d
  for name in $(ls "$dir"); do
    source "$dir"/"$name"
  done
  unset dir
fi

# helper functions such as 'get_pod' for kubernetes
source ~/Documents/scripts/kubernetes/source-me_common_functions.sh
#------------


#------------
# Darwin misc

if [ "$(uname)" = Darwin ]; then
  :
fi

#------------
# bash history
#

# make bash history saving immediate and shared between sessions
# taken from https://askubuntu.com/a/115625
#
# history -c clears the history of the running session. This will reduce the history counter by the amount of $HISTSIZE.
# history -r read the contents of $HISTFILE and insert them in to the current running session history.
# This will raise the history counter by the amount of lines in $HISTFILE
shopt -s histappend                      # append to history, don't overwrite it
export HISTSIZE=10000000
export HISTFILESIZE=10000000
export PROMPT_COMMAND="history -a; history -c; history -r;  source ~/.sh_functions; $PROMPT_COMMAND"



#
# fzf reverse search
#
__fzf_history ()
{
    builtin history -a;
    builtin history -c;
    builtin history -r;
    builtin typeset \
        READLINE_LINE_NEW="$(
            HISTTIMEFORMAT= builtin history |
            command fzf +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r |
            command sed '
                /^ *[0-9]/ {
                    s/ *\([0-9]*\) .*/!\1/;
                    b end;
                };
                d;
                : end
            '
        )";

        if
                [[ -n $READLINE_LINE_NEW ]]
        then
                builtin bind '"\er": redraw-current-line'
                builtin bind '"\e^": magic-space'
                READLINE_LINE=${READLINE_LINE:+${READLINE_LINE:0:READLINE_POINT}}${READLINE_LINE_NEW}${READLINE_LINE:+${READLINE_LINE:READLINE_POINT}}
                READLINE_POINT=$(( READLINE_POINT + ${#READLINE_LINE_NEW} ))
        else
                builtin bind '"\er":'
                builtin bind '"\e^":'
        fi
}

#
# enable fzf reverse search
#
builtin set -o histexpand;
builtin bind -x '"\C-x1": __fzf_history';
builtin bind '"\C-r": "\C-x1\e^\er"'

# --------------------------


# --------------------------
# prompt style start
#

# !! remember to ecaspe dollar signs, otherwise PS1 caches the output !!
#source ~/Documents/scripts/source-me_prompt-style.sh
#source ~/Documents/scripts/tmux_info.sh

#export PS1="[ \$(tmux_id) |  $LIGHT_GREEN\w$NC$PURPLE\$(__git_ps1)$NC \
#\$(show_kubernetes_context)$YELLOW\$(show_kubernetes_namespace)$NC]\n$ "


export PS1="\$(refresh_tmux_kubecontext)[ $LIGHT_GREEN\w$NC$PURPLE\$(__git_ps1)$NC${YELLOW}\$(show_openstack_project)${BLUE} $RED\$?$NC ]\n$ "

#
# prompt style end
# --------------------------

[[ -x "$(which xrdb)" ]] && xrdb -merge ~/.Xdefaults

