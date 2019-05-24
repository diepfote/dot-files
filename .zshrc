[[ ! -o login ]] && echo 'Interactive' || return

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## Jump to start or end of line
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

## Do not delete characters on CTRL+ARROW; jump words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

## Press up or down to traverse history
bindkey '^[[A' up-line-or-search                                                
bindkey '^[[B' down-line-or-search


## taken from: https://bbs.archlinux.org/viewtopic.php?pid=201976#p201976
#autoload zkbd
#[[ ! -f ${ZDOTDIR:-$HOME}/.zkbd/$TERM-$VENDOR-$OSTYPE ]] && zkbd
#source ${ZDOTDIR:-$HOME}/.zkbd/$TERM-$VENDOR-$OSTYPE

#[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
#[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
#[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
#[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
#[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
#[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
#[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
#[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
#[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
#[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
#[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char

export VISUAL=vi
export EDITOR=vi


##############################################################################
# History Configuration
##############################################################################
## taken from: https://gist.github.com/matthewmccullough/787142
HISTSIZE=5000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000               #Number of history entries to save to disk
#HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed

########################

# autocompletion
autoload -Uz compinit
compinit
setopt COMPLETE_ALIASES
#zstyle ':completion:*' rehash true
# autocompletion with arrow keys
zstyle ':completion:*' menu select

# kubectl autocompletion
source <(kubectl completion zsh)

