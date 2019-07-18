set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
set number

" display filename for current file
"
set ls=2

syntax on
filetype plugin indent on

" security fixes
"
set modelines=0
set nomodeline


" start custom tab settings
autocmd filetype py set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
au bufenter *.c set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
au bufenter *.hs set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

  " assembly  
  au bufenter *.asm set tabstop=4 softtabstop=0 expandtab! shiftwidth=4 smarttab
  au bufenter *.S set tabstop=4 softtabstop=0 expandtab! shiftwidth=4 smarttab
  au bufenter *.s set tabstop=4 softtabstop=0 expandtab! shiftwidth=4 smarttab

  " do not expand tabs
  au bufenter *.cfg set tabstop=2 softtabstop=0 expandtab! shiftwidth=2 smarttab
" end custom tab settings


" spell checking for latex files (de-AT)
autocmd BufRead,BufNewFile *.tex setlocal spell spelllang=de_at
" set ft
autocmd BufRead,BufNewFile *.bib set ft=tex
autocmd BufRead,BufNewFile *.local set ft=sh
autocmd BufRead,BufNewFile *.profile set ft=sh
autocmd BufRead,BufNewFile *.rc set ft=sh
autocmd BufRead,BufNewFile *.service set ft=sh
autocmd BufRead,BufNewFile *.conf set ft=sh


"colorscheme seti "https://www.archlinux.org/packages/community/any/vim-seti/  or   https://github.com/trusktr/seti.vim
"colorscheme PaperColor "https://raw.githubusercontent.com/NLKNguyen/papercolor-theme/master/colors/PaperColor.vim
"colorscheme artesanal "https://raw.githubusercontent.com/wimstefan/vim-artesanal/master/colors/artesanal.vim
"colorscheme github "https://raw.githubusercontent.com/acarapetis/vim-colors-github/master/colors/github.vim
"-- solarized themes start --
"colorscheme solarized8_flat "git clone --depth=1 https://github.com/lifepillar/vim-solarized8 --> extract colors/ into ~/.vim/colors
"colorscheme solarized8
"colorscheme solarized8_high
"-- solarized themes end --
"colorscheme elflord  " used in the artofexploitation vm
"colorscheme luna  " curl -L 'https://raw.githubusercontent.com/notpratheek/vim-luna/master/colors/luna-term.vim' -o ~/.vim/colors/luna.vim


"""vim-fish start
" Set up :make to use fish for syntax checking.
autocmd FileType fish compiler fish
"""vim-fish end


" set lead key to space
let mapleader = "\<space>"
" set shorcut for tagbar plugin
nmap <f8> :TagbarToggle<cr>
" set path to tags file
set tags=.git/tags
filetype plugin on
call plug#begin('~/.vim/plugged')
"    'github_user/repo_name'
Plug 'dag/vim-fish'
"Plug 'mattn/emmet-vim'

call plug#end()
