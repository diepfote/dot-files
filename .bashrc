# shellcheck disable=SC1090,SC1091

# If not running interactively, don't do anything
[[ $- != *i* ]] && [[ -z "$BASH_SOURCE_IT" ]] && return


[ "$(uname)" = Darwin ] && export TERM=screen-256color

# ----
# keybindings | bind settings | binding settings

# undefine previous assignment!
stty werase undef

# set '/' as word delmiter
#bind '\C-w:unix-filename-rubout'

# set '-', '/' etc. as word delmiters
bind '"\C-w":backward-kill-word'

# do not execute multiline pastes immediately
bind 'set enable-bracketed-paste'

#
# ----

if [[ "$(hostname)" =~ ^[a-z0-9]+$ ]] ||\
   [ "$(hostname)" = docker-desktop ] || \
   [[ "$(hostname)" =~ lima* ]] ; then
  export IN_CONTAINER=true
else
  export IN_CONTAINER=''
fi

if [ -z "$IN_CONTAINER" ]; then

  if [ "$(tty)" = /dev/tty1 ] && \
     [ "$(uname)" = Linux ]; then
    # startxfce4
    startx  # i3 based on ~/.xinitrc
    return
  fi

  if [[ -z "$TMUX" ]] && [ -z "$BASH_SOURCE_IT" ]; then
    default_tmux_cmd=(tmux -2 -u new)  # -u -> utf-8; -2 -> force 256 colors
    "${default_tmux_cmd[@]}"
    HISTFILE=''
    return  # do not source anything if outside tmux sessions
  fi
else
  HISTFILE=~/.container/.bash_history
  export USER=build-user
fi




source ~/Documents/scripts/source-me/bash-nnn.sh


source ~/.password-store/.extensions/pass-tail.bash.completion
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

source ~/Documents/scripts/source-me/common-functions.sh
source ~/Documents/scripts/source-me/posix-compliant-shells.sh

for name in ~/Documents/scripts/source-me/completions_*; do
  source "$name"
done

  source ~/Documents/scripts/private/source-me/posix-compliant-shells.sh

if [ "$(uname)" = Darwin ]; then

  source /usr/local/share/bash-completion/bash_completion


  source ~/Documents/scripts/source-me/darwin/posix-compliant-shells.sh
  for name in ~/Documents/scripts/source-me/darwin/completions_*; do
    source "$name"
  done
  for name in ~/Documents/scripts/kubernetes/source-me/completions_*; do
    source "$name"
  done


  # mostly kubernetes - cc only
  source ~/Documents/scripts/cc/source-me/posix-compliant-shells.sh
  source ~/Documents/scripts/cc/source-me/completions_* || true

  # bb only
  source ~/Documents/scripts/bb/source-me

  if [[ -x /usr/local/bin/kubectl ]]; then
    filename="/tmp/_kubectl-completions"
    _patched_kubectl_completions="$filename-patched"

    if [ ! -e "$_patched_kubectl_completions" ]; then
      kubectl completion bash > "$filename"
      ~/Documents/python/tools/kubectl-client/completion_script_patcher.py "$filename" > "$_patched_kubectl_completions"
    fi

    source "$_patched_kubectl_completions"
    unset filename _patched_kubectl_completions
  fi

  if [[ -x /usr/local/bin/oc ]]; then
    filename="/tmp/_oc-completions"
    _patched_oc_completions="$filename-patched"

    if [ ! -e "$_patched_oc_completions" ]; then
      oc completion bash > "$filename"
      ~/Documents/python/tools/oc-client/completion_script_patcher.py "$filename" > "$_patched_oc_completions"
    fi

    source "$_patched_oc_completions"
    unset filename _patched_oc_completions
  fi

  # [[ -x /usr/local/bin/openstack ]] && source <(openstack complete --shell bash)

  # helper functions such as 'get_pod' for kubernetes
  source ~/Documents/scripts/kubernetes/source-me/common-functions.sh
else
  for name in ~/Documents/scripts/source-me/linux/*; do
    source "$name"
  done

  source ~/Documents/scripts/private/source-me/linux/posix-compliant-shells.sh
fi


#------------

# --------------------------
shopt -s autocd   # assume one wants to cd given a directory
shopt -s cdspell  # autocorrect spelling errors for cd
shopt -s nocaseglob  # case-insensitive-globbing in pathname expansion
# --------------------------


# bash history
#

shopt -s histappend                      # append to history, don't overwrite it
export HISTSIZE='blub'
export HISTFILESIZE='blub'
export HISTCONTROL=ignoreboth:erasedups  # no duplicates, only keeps the latest of any command

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

source ~/Documents/scripts/source-me/bash-prompt.sh
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
#is_ascii() { python3 -c 'import sys; (sys.argv[1]).encode("utf-8").decode("ascii")' "$*" 2>/dev/null || return 1;  }
#trap 'source ~/.sh_functions && is_ascii "$BASH_COMMAND"  || $(remove_non-ascii_characters "$BASH_COMMAND")' DEBUG
#shopt -s extdebug  # prevent command from running if not ascii --> do else

# --------------------------

