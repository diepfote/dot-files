#set -x
#return

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


if [[ -z "$TMUX" ]]; then
  default_tmux_cmd="tmux -2 -u new"  # -u -> utf-8; -2 -> force 256 colors

  if ! tmux list-sessions 2>/dev/null; then
    $default_tmux_cmd 'sleep 2; tmux source ~/.tmux.conf; tmux detach'
  else
    $default_tmux_cmd
  fi
fi

# ----
# keybindings | bind settings | binding settings

# undefine previous assignment!
stty werase undef

# set '/' as word delmiter
#bind '\C-w:unix-filename-rubout'

# set '-', '/' etc. as word delmiters
bind '"\C-w":backward-kill-word'

#
# ----

# ----
# nnn
n ()
{
#BSD 2-Clause License

#Copyright (c) 2014-2016, Lazaros Koromilas <lostd@2f30.org>
#Copyright (c) 2014-2016, Dimitris Papastamos <sin@2f30.org>
#Copyright (c) 2016-2020, Arun Prakash Jana <engineerarun@gmail.com>
#All rights reserved.

#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are met:

#* Redistributions of source code must retain the above copyright notice, this
  #list of conditions and the following disclaimer.

#* Redistributions in binary form must reproduce the above copyright notice,
  #this list of conditions and the following disclaimer in the documentation
  #and/or other materials provided with the distribution.

#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
#FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}
#
# ----




# configure to use direnv
eval "$(direnv hook bash 2>/dev/null || true)"

source ~/Documents/scripts/source-me_posix-compliant-shells.sh
alias cd=pushd

# -----
# kubectl | kubernetes  just bash
#

# kubernetes autocompletion | kubectl autocompletion
[[ -x kubectl ]] && tsource <(kubectl completion bash)

# ----
# Darwin
if [ "$(uname)" = Darwin ]; then
  dir=/usr/local/etc/bash_completion.d
  for name in $(ls "$dir"); do
    source "$dir"/"$name"
  done
  unset dir
fi

bash_completion_file=/usr/local/etc/profile.d/bash_completion.sh
[[ -f "$bash_completion_file" ]] && source "$bash_completion_file"
# ----

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
export PROMPT_COMMAND="history -a; history -c; history -r; remove_non-ascii_characters ~/.bash_history ~/.bash_history 1>/dev/null 2>/dev/null; $PROMPT_COMMAND"


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


export PS1="\$(refresh_tmux_kubecontext)[ $LIGHT_GREEN\w$NC$PURPLE\$(__git_ps1)$NC${YELLOW}\$(show_openstack_project)$NC ]\n$ "

#
# prompt style end
# --------------------------


# --------------------------
# preexec hook
#
# preexec and precmd hook functions for Bash in the style of Zsh. They aim to emulate the behavior as described for Zsh.
# https://superuser.com/questions/175799/does-bash-have-a-hook-that-is-run-before-executing-a-command/175802#175802
# http://zsh.sourceforge.net/Doc/Release/Functions.html#Hook-Functions
# https://github.com/rcaloras/bash-preexec
#
#file=~/.bash-preexec.sh
#[ ! -f "$file" ] && curl -s https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o "$file"
#source "$file"
#preexec() { source ~/.sh_functions; }

## check which functions will be run before executing a line ->
## $ echo ${preexec_functions[@]}

## Define some function to use preexec
#preexec_hello_world() { echo "You just entered $1"; }
#preexec_set_test() { set -- asdf 2143; }
## Add it to the array of functions to be invoked each time.
#preexec_functions+=(preexec_hello_world)
#preexec_functions+=(preexec_set_test)


# do not run command if it contains a non-ascii character
# remove it first, then run the command in a subshell
#
#
is_ascii() { python3 -c 'import sys; (sys.argv[1]).encode("utf-8").decode("ascii")' "$*" 2>/dev/null || return 1;  }
trap 'source ~/.sh_functions && is_ascii "$BASH_COMMAND"  || $(remove_non-ascii_characters "$BASH_COMMAND")' DEBUG
#shopt -s extdebug  # prevent command from running if not ascii --> do else

# --------------------------

