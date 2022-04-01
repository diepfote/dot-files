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


# configure to use direnv
eval "$(direnv hook zsh 2>/dev/null || true)"

source ~/Documents/scripts/source-me/common-functions.sh
source ~/Documents/scripts/source-me/posix-compliant-shells.sh
source ~/Documents/scripts/source-me/completions*

source ~/Documents/scripts/source-me/darwin/posix-compliant-shells.sh
source ~/Documents/scripts/source-me/darwin/completions*

source ~/Documents/scripts/bb/source-me

source ~/Documents/scripts/cc/source-me/posix-compliant-shells.sh
source ~/Documents/scripts/cc/source-me/completions*

