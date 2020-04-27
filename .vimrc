" do not write backup files and disable viminfo
set nobackup
set nowritebackup
set viminfo=


" default file settings
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

if exists("loaded_less")
  set nonumber
else
  set number
endif

" display filename for current file
"
set ls=2

syntax on
filetype plugin indent on

" --------------
" security fixes
"
set modelines=0
set nomodeline
" --------------

" enable mouse pointer clicks!
set mouse=a


" ------------------------
"  reload file on external change
au FocusGained,BufEnter * :silent! !  " trigger file reload when buffer gets focus

" ------------------------
" start custom tab settings
autocmd filetype py set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
au bufenter *.c set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
au bufenter *.hs set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

  " assembly
  au bufenter *.asm set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
  au bufenter *.S set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
  au bufenter *.s set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

  " do not expand tabs
  au bufenter *.cfg set tabstop=2 softtabstop=0 expandtab! shiftwidth=2 smarttab
" end custom tab settings
" ------------------------


" spell checking for latex files (de-AT)
"
autocmd BufRead,BufNewFile *.tex setlocal spell spelllang=de_at

" -----------------
" set ft
autocmd BufRead,BufNewFile *.bib set ft=tex
autocmd BufRead,BufNewFile *.rc set ft=sh
autocmd BufRead,BufNewFile *.envrc set ft=sh
autocmd BufRead,BufNewFile *.custom-envrc set ft=sh
autocmd BufRead,BufNewFile *.service set ft=sh
autocmd BufRead,BufNewFile *.conf set ft=sh
autocmd BufRead,BufNewFile *.hook set ft=sh



autocmd BufNewFile,BufRead /etc/firejail/*.profile      set filetype=firejail
autocmd BufNewFile,BufRead /etc/firejail/*.local        set filetype=firejail
autocmd BufNewFile,BufRead /etc/firejail/*.inc          set filetype=firejail
autocmd BufNewFile,BufRead ~/.config/firejail/*.profile set filetype=firejail
autocmd BufNewFile,BufRead ~/.config/firejail/*.local   set filetype=firejail
autocmd BufNewFile,BufRead ~/.config/firejail/*.inc     set filetype=firejail

autocmd BufNewFile,BufRead ~/Documents/firejail/etc/*.profile set filetype=firejail
autocmd BufNewFile,BufRead ~/Documents/firejail/etc/*.local   set filetype=firejail
autocmd BufNewFile,BufRead ~/Documents/firejail/etc/*.inc     set filetype=firejail

" -----------------

" -----------------
" nerdcommenter delimiter settings for custom file types
let g:NERDCustomDelimiters = {
    \ 'firejail': { 'left': '#'}
\ }

"-----------------

" -----------------
" remove trailing whitespace in lines on save for every filetype
autocmd BufWritePre * %s/\s\+$//e
" -----------------



"colorscheme seti "https://www.archlinux.org/packages/community/any/vim-seti/  or   https://github.com/trusktr/seti.vim
"colorscheme PaperColor "curl -L 'https://raw.githubusercontent.com/NLKNguyen/papercolor-theme/master/colors/PaperColor.vim' -o ~/.vim/colors/PaperColor.vim
"colorscheme artesanal "https://raw.githubusercontent.com/wimstefan/vim-artesanal/master/colors/artesanal.vim
"colorscheme github "curl -L 'https://raw.githubusercontent.com/acarapetis/vim-colors-github/master/colors/github.vim' -o ~/.vim/colors/github.vim
"-- solarized themes start --
"colorscheme solarized8_flat "git clone --depth=1 https://github.com/lifepillar/vim-solarized8 --> extract colors/ into ~/.vim/colors
"colorscheme solarized8
"colorscheme solarized8_high
"-- solarized themes end --
"colorscheme elflord  " used in the artofexploitation vm
"colorscheme luna  " curl -L 'https://raw.githubusercontent.com/notpratheek/vim-luna/master/colors/luna-term.vim' -o ~/.vim/colors/luna.vim
"colorscheme breve  " curl -L 'https://raw.githubusercontent.com/AlessandroYorba/Breve/master/colors/breve.vim' -o ~/.vim/colors/breve.vim



" -----------------
" vim-fish start
" Set up :make to use fish for syntax checking.
autocmd FileType fish compiler fish
" vim-fish end
" -----------------



" -----------------------
" ncm2 settings and tips
"
" ####
" SETTINGS
  " enable ncm2 for all buffers

  if has("nvim")
    autocmd BufEnter * call ncm2#enable_for_buffer()

    " IMPORTANT: :help Ncm2PopupOpen for more information
    set completeopt=noinsert,menuone,noselect

    set termguicolors
    colorscheme lingodirector  "-> 'flazz/vim-colorschemes'

  endif
" ####


" ####
" TIPS
  " suppress the annoying 'match x of y', 'The only match' and 'Pattern not
  " found' messages
  set shortmess+=c

  " CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
  inoremap <c-c> <ESC>


  if has("nvim")
    " Use <TAB> to select the popup menu:
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  endif
" ####
"
" -----------------------

" -----------------------
" tmux-complete settings
"
" to enable fuzzy matching disable filter_prefix -> set to 0
let g:tmuxcomplete#asyncomplete_source_options = {
            \ 'name':      'tmuxcomplete',
            \ 'whitelist': ['*'],
            \ 'config': {
            \     'splitmode':      'words',
            \     'filter_prefix':   0,
            \     'show_incomplete': 1,
            \     'sort_candidates': 0,
            \     'scrollback':      0,
            \     'truncate':        0
            \     }
            \ }

" -----------------------



" set lead key to space
let mapleader = "\<space>"
" set shorcut for tagbar plugin
nmap <f8> :TagbarToggle<cr>
" set path to tags file
set tags=.git/tags
filetype plugin on
call plug#begin('~/.vim/plugged')
"    'github_user/repo_name'
Plug 'scrooloose/nerdcommenter'  " removed from pacman
Plug 'majutsushi/tagbar'  " removed from pacman
Plug 'dag/vim-fish'
"Plug 'mattn/emmet-vim'




if has('nvim')

  " --------------
  "  ncm2
  "
  Plug 'roxma/nvim-yarp', { 'do': ':UpdateRemotePlugins' } " dependency for ncm2
  Plug 'ncm2/ncm2', { 'do': ':UpdateRemotePlugins' }

  " NOTE: you need to install completion sources to get completions. Check
  " our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
  Plug 'ncm2/ncm2-bufword'
  Plug 'ncm2/ncm2-path'
  Plug 'ncm2/ncm2-jedi' " python completions


  " common lisp
  "Plug 'HiPhish/ncm2-vlime'  "  completions taken from vlime (requires
    "connection to vlime server)
  "Plug 'l04m33/vlime'  "https://github.com/l04m33/vlime#quickstart

  "
  " ncm2 end
  " --------------


  " -----------------------------------
  " language client start
  Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }

  "--------
  " language client settings
  "
  " Required for operations modifying multiple buffers like rename.
  set hidden

  let g:LanguageClient_serverCommands = {
      \ 'python': ['pyls'],
      \ 'sh': ['bash-language-server', 'start'],
      \ 'yaml' : ['yaml-language-server'],
      \ }

  "let os=substitute(system('uname'), '\n', '', '')
  "if os == 'Darwin' || os == 'Mac'

  "elseif os == 'Linux'
    "let g:LanguageClient_serverCommands = {
        "\ 'python': ['/usr/bin/pyls'],
        ""\ 'sh': ['bash-language-server', 'start'],
        ""\ 'yaml' : ['/usr/bin/yaml-language-server'],
        "\ }

  "endif


  nnoremap <F5> :call LanguageClient_contextMenu()<CR>

  "
  " language server end
  " -----------------------------------


  " -----------------------------------
  "  semshi - semantic python highlighting start
  Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

  function CustomSemshiHighlightingColor()
    hi semshiLocal           ctermfg=209 guifg=#ff875f
    hi semshiGlobal          ctermfg=214 guifg=#ffaf00
    hi semshiImported        ctermfg=214 guifg=#ffaf00 cterm=bold gui=bold
    hi semshiParameter       ctermfg=75  guifg=#5fafff
    hi semshiParameterUnused ctermfg=117 guifg=#87d7ff cterm=underline gui=underline
    hi semshiFree            ctermfg=218 guifg=#ffafd7
    hi semshiBuiltin         ctermfg=207 guifg=#ff5fff
    hi semshiAttribute       ctermfg=49  guifg=#00ffaf
    hi semshiSelf            ctermfg=249 guifg=#b2b2b2
    hi semshiUnresolved      ctermfg=226 guifg=#ffff00 cterm=underline gui=underline
    hi semshiSelected        ctermfg=231 guifg=#000000 ctermbg=161 guibg=#f0e8a5

    hi semshiErrorSign       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
    hi semshiErrorChar       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
    sign define semshiError text=E> texthl=semshiErrorSign
  endfunction
  autocmd FileType python call CustomSemshiHighlightingColor()


  "  semshi - semantic python highlighting end
  " -----------------------------------

  Plug 'flazz/vim-colorschemes'
  Plug 'wellle/tmux-complete.vim' " vim completions from other tmux panes (used by ncm2)
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
endif

call plug#end()

