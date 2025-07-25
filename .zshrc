# If not running interactively, don't do anything
[[ $- != *i* ]] && [[ -z "$BASH_SOURCE_IT" ]] && return

### Jump to start or end of line
# bindkey "^[[H" beginning-of-line
# bindkey "^[[F" end-of-line
# bindkey "\e[3~" delete-char
# bindkey '\e[H' beginning-of-line
# bindkey '\e[F' end-of-line
# bindkey '\e[1~' beginning-of-line
# bindkey '\e[4~' end-of-line
#
#bindkey "${terminfo[khome]}" beginning-of-line
#bindkey "${terminfo[kend]}" end-of-line
#bindkey "${terminfo[kdch1]}" delete-char

## Do not delete characters on CTRL+ARROW; jump words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word


## taken from: https://bbs.archlinux.org/viewtopic.php?pid=201976#p201976
#autoload zkbd
#[[ ! -f ${ZDOTDIR:-$HOME}/.zkbd/$TERM-:0 ]] && zkbd
#source ${ZDOTDIR:-$HOME}/.zkbd/$TERM-:0

export VISUAL=vi
export EDITOR=vi

# do not tell me about failed globs
unsetopt nomatch


##############################################################################
# History Configuration
# taken from: https://gist.github.com/matthewmccullough/787142

HISTSIZE=300000              # How many lines of history to keep in memory
HISTFILE=~/.zsh_history      # Where to save history to disk
SAVEHIST=300000              # Number of history entries to save to disk
#HISTDUP=erase               # Erase duplicates in the history file
setopt    appendhistory     # Append history to the history file (no overwriting)
setopt    sharehistory      # Share history across terminals
setopt    incappendhistory  # Immediately append to the history file, not just when a term is killed

##############################################################################

# autocompletion
autoload -Uz compinit bashcompinit
compinit
bashcompinit
setopt COMPLETE_ALIASES
#zstyle ':completion:*' rehash true
# autocompletion with arrow keys
zstyle ':completion:*' menu select

# stupid workaround for $SHELL set to whatever you did with `chsh -s`
# on Mac OS
export ZSH=true


export PATH="/opt/homebrew/bin:$PATH"


# do not load custom posix-compliant config -> I use zsh as a fallback
return

# fzf reverse search
if fzf --help >/dev/null 2>&1; then
  # https://github.com/junegunn/fzf/issues/1304
  source <(fzf --zsh)
fi

# configure to use direnv
if direnv --help >/dev/null 2>&1; then
  source <(fzf --zsh)
  eval "$(direnv hook zsh 2>/dev/null || true)"
fi

source ~/Repos/scripts/source-me/common-functions.sh
source ~/Repos/scripts/source-me/posix-compliant-shells.sh
source ~/Repos/scripts/source-me/completions*

source ~/Repos/scripts/kubernetes/source-me/common-functions.sh

source ~/Repos/scripts/source-me/darwin/posix-compliant-shells.sh
source ~/Repos/scripts/source-me/darwin/completions*

source ~/Repos/scripts/bb/source-me

# source ~/Repos/scripts/cc/source-me/posix-compliant-shells.sh
# source ~/Repos/scripts/cc/source-me/completions*



# Lima BEGIN
# Make sure iptables and mount.fuse3 are available
PATH="$PATH:/usr/sbin:/sbin"
export PATH
# Lima END
