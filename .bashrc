# shellcheck disable=SC1090,SC1091

# If not running interactively, don't do anything
[[ $- != *i* ]] && [[ -z "$BASH_SOURCE_IT" ]] && return
if [ "$(uname)" = Darwin ]; then
  export TERM=screen-256color

  # Fix /opt/homebrew/bin is set at the veryeend of PATH
  # this messes with every `bin/` folder I have set up
  PATH="$(echo "$PATH" | /opt/homebrew/opt/gnu-sed/libexec/gnubin/sed -r 's#:/opt/homebrew/bin##g')"
  export PATH="/opt/homebrew/bin:$PATH"
fi

# ----
# bash history START
#

export HISTSIZE='blub'
export HISTFILESIZE='blub'
export HISTCONTROL='ignorespace:erasedups'  # man bash

# TODO add additional?
# based on https://github.com/justinmk/config/blob/9332827a1cbcc2fc144364459d7f65c736b11938/.bashrc#L28
HISTIGNORE='exit:cd:ls:bg:fg:history:f:fd'

# Non-default history file, to avoid accidental truncation.
# -> copy default file if non-default does not exist <-
# snatched from https://github.com/justinmk/config/blob/9332827a1cbcc2fc144364459d7f65c736b11938/.bashrc#L22
[ -f "$HOME/.bash_history_x" ] || { [ -f "$HOME/.bash_history" ] && cp "$HOME/.bash_history" "$HOME/.bash_history_x" ; }
HISTFILE="$HOME/.bash_history_x"

# ----


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


# TODO if you want to DEBUG this bashrc
# return

if ! hostname >/dev/null 2>&1; then
  # if the hostname command is not available:
  # do not set anything else for bash
  return
fi
# ..................................................



# stupid workaround for $SHELL set to whatever you did with `chsh -s`
# on Mac OS
export ZSH=''


source ~/Documents/scripts/source-me/bash-nnn.sh
source ~/Documents/scripts/source-me/bash-fzf-reverse-search.sh


source ~/.password-store/.extensions/pass-tail.bash.completion
export PASSWORD_STORE_ENABLE_EXTENSIONS=true


source ~/Documents/scripts/source-me/posix-compliant-shells.sh

source ~/Documents/scripts/private/source-me/posix-compliant-shells.sh

system="$(uname)"
if [ "$system" = Darwin ]; then

  source ~/Documents/scripts/source-me/darwin/posix-compliant-shells.sh

  # ------------------------------------------------
  # kubectl completion patching START

  _save-timestamped-kubernetes-completions () {

    local completion_path completion_filename backup_sha new_sha backup_store_loc

    _copy_compl_and_timestamp () {
      cp "$completion_path" "$backup_store_loc/$completion_filename-$(/opt/homebrew/opt/coreutils/libexec/gnubin/date --iso-8601=seconds | /opt/homebrew/opt/gnu-sed/libexec/gnubin/sed 's#:#-#g')"
    }

    completion_path="$1"
    completion_filename="$(basename "$completion_path")"
    backup_store_loc=~/Desktop/no-backup

    latest_compl_backup="$(find-sorted "$backup_store_loc" -name "$completion_filename*" | head -n1)"

    save_compl=''
    if [ -n "$latest_compl_backup" ]; then
      backup_sha="$(sha256sum "$latest_compl_backup" | awk '{ print $1 }')"
      new_sha="$(sha256sum "$completion_path" | awk '{ print $1 }')"

      if [ "$backup_sha" != "$new_sha" ]; then
        save_compl=true
      fi
    else
        save_compl=true
    fi

    if [ -n "$save_compl" ]; then
      _copy_compl_and_timestamp
    fi
  }

  if [[ -x /opt/homebrew/bin/kubectl ]]; then
    # remove default completions
    unlink /opt/homebrew/etc/bash_completion.d/kubectl 2>/dev/null || true

    filename="/tmp/_kubectl-completions"
    _patched_kubectl_completions="$filename-patched"

    if [ ! -e "$_patched_kubectl_completions" ]; then
      kubectl completion bash > "$filename"
      ~/Documents/python/tools/kubectl-client/completion_script_patcher.py "$filename" > "$_patched_kubectl_completions"
    fi

    source "$_patched_kubectl_completions"
    _save-timestamped-kubernetes-completions "$filename"
    unset filename _patched_kubectl_completions
  fi


  # kubectl completion patching END
  # ------------------------------------------------

  # [[ -x /opt/homebrew/bin/openstack ]] && source <(openstack complete --shell bash)


  for name in ~/Documents/scripts/source-me/darwin/completions_*; do
    source "$name"
  done
  for name in ~/Documents/scripts/kubernetes/source-me/completions_*; do
    source "$name"
  done

  # mostly kubernetes - cc only
  source ~/Documents/scripts/cc/source-me/posix-compliant-shells.sh
  for file in ~/Documents/scripts/cc/source-me/completions_*; do
    source "$file"
  done

  # bb only
  source ~/Documents/scripts/bb/source-me/posix-compliant-shells.sh
  for file in ~/Documents/scripts/bb/source-me/completions_*; do
    source "$file"
  done


  # helper functions such as 'get_pod' for kubernetes
  source ~/Documents/scripts/kubernetes/source-me/common-functions.sh


  # --------------------------------------------------------------------------------------------------
  # LEAVE THIS AT THE END!
  # we do not want fun like this again:
  # ```
  # bash: /opt/homebrew/etc/bash_completion.d/poetry: line 40: syntax error near unexpected token `clear'
  # bash: /opt/homebrew/etc/bash_completion.d/poetry: line 40: `            (cache clear)'
  # ```
  #
  # remove docker completions
  unlink /opt/homebrew/etc/bash_completion.d/docker 2>/dev/null || true
  # source all brew installed completions
  source /opt/homebrew/share/bash-completion/bash_completion
  # --------------------------------------------------------------------------------------------------

elif [ "$system" = Linux ]; then
  # Arch Linux

  # for yay/pacman in combination with trickle
  # rate KB/s
  #
  # check `pacman` wrapper to see why this is neccessary
  pacman_bandwidth_limit_file=/tmp/pacman-bandwidth-limit
  if [ ! -f "$pacman_bandwidth_limit_file" ]; then
    echo -n 500 > "$pacman_bandwidth_limit_file"
  fi

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



# Lima BEGIN
# Make sure iptables and mount.fuse3 are available
PATH="$PATH:/usr/sbin:/sbin"
export PATH
# Lima END
