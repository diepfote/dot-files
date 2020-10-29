"Vim needs a more POSIX compatible shell than fish for certain functionality to
"work, such as `:%!`, compressed help pages and many third-party addons.  If you
"use fish as your login shell or launch Vim from fish, you need to set `shell`
"to something else in your `~/.vimrc`, for example:
if &shell =~# 'fish$'
    set shell=bash
endif

" set lead key to space
" leave this at the top!!!
"
let mapleader = "\<space>"

set hidden  " do not require buffer writes before switching buffers

map <F4> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>

" resize windows with arrow keys
nnoremap <c-down>  :resize +2<cr>
nnoremap <c-up>  :resize -2<cr>
nnoremap <c-left>  :vertical resize -2<cr>
nnoremap <c-right>  :vertical resize +2<cr>


"disable compatibility
set nocompatible
" 'faster' backspace behavior I guess?
set backspace=indent,eol,start


" customize the wildmenu
set wildignore+=*.dll,*.o,*.pyc,*.bak,*.exe,*.jpg,*.jpeg,*.png,*.gif,*$py.class,*.class,*/*.dSYM/*,*.dylib,*.so,*.PNG,*.JPG
set wildmenu
set wildmode=longest:full,full

" for sidebars?
let g:netrw_list_hide='^\.\(pyc\|pyo\)$'



" sudo write this, no use with firejail obviously
cmap W! w !sudo tee % >/dev/null


" Small helper that inserts a random uuid4 on ^U
" ----------------------------------------------
fun! InsertUUID4()
python3 << endpython
if 1:
    import uuid, vim
    vim.command('return "%s"' % str(uuid.uuid4()))
endpython
endfun
inoremap <c-u> <C-R>=InsertUUID4()


" do not write backup files
set nobackup
set nowritebackup


let os=substitute(system('uname'), '\n', '', '')
if os == 'Darwin' || os == 'Mac'
  " If installed using Homebrew
  set rtp+=/usr/local/opt/fzf
elseif os == 'Linux'
  " to use :FZF
  set rtp+=/usr/bin/fzf
endif



if has("nvim")
  " Tell vim to remember certain things when we exit
  "  '10  :  marks will be remembered for up to 10 previously edited files
  "  "100 :  will save up to 100 lines for each register
  "  :20  :  up to 20 lines of command-line history will be remembered
  "  %    :  saves and restores the buffer list
  "  n... :  where to save the viminfo files
  set viminfo='10,\"100,:20,%,n~/.viminfo
" ----------


  " jump to last location
  function! ResCur()
    if line("'\"") <= line("$")
      normal! g`"
      return 1
    endif
  endfunction

  augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
  augroup END


  set termguicolors
  colorscheme lingodirector  "-> 'flazz/vim-colorschemes'
  " set search highlight color
  highlight Search guibg='LightBlue' guifg='NONE'
else
  set viminfo=
end



" disable swapfile
set noswapfile
" enable undofile -> undo edits even after closing a file
set undofile

set fsync  " flush file to disk



" keep 5 lines at the top or bottom,
" depends on the scroll direction
set scrolloff=5

set cursorline

" do not show titles in bold print etc.
let html_no_rendering=1

"
set list


" --------------------------------
let g:listchars_for_space_enabled = 0
set listchars=tab:▴\ ,extends:#,nbsp:⍽
function! ToggleListCharsOptions()
  if ! g:listchars_for_space_enabled
    let g:listchars_for_space_enabled = 1
    set listchars=tab:▴\ ,extends:#,nbsp:⍽,space:·
  else
    let g:listchars_for_space_enabled = 0
    set listchars=tab:▴\ ,extends:#,nbsp:⍽
  endif
endfunction

nmap <leader>ss  :call ToggleListCharsOptions()<cr>
" --------------------------------


" wrapping settings
set colorcolumn=85 " display vertical line to show 85 character limit


" -----------
" statusline start

set statusline =%F\ %r%m%{ObsessionStatus()}

set statusline +=%=%c
" display character value for the character the cursor is hovering over
"set statusline +=%=%c%=cv:%b,0x%B

set statusline +=%=ft=%y

" statusline end
" -----------


" ---------
"  formatting start
set formatoptions=qrn1  " refer to https://neovim.io/doc/user/change.html#fo-table



com! FormatXML :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"
nmap <leader>f :FormatXML<Cr>

com! FormatJSON :%!python3 -m json.tool
nmap <leader>F :FormatJSON<Cr>


"  formatting start
" ---------



if exists("loaded_less")  " make vim behave like less
  set nonumber
else
  " useful for motion commands
  set relativenumber
  set number
endif

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
"  focus related
au FocusGained,BufEnter * :silent! !  " trigger file reload when buffer gets focus
"au FocusLost * :wa " save on focus loss


" ------------------------
" change to directory of current file automatically
autocmd BufEnter * lcd %:p:h

" ------------------------
" start custom tab settings

" default
function! DefaultTabSettings()
    " Don't set custom tab settings
    " for these filetypes:
    "
    "if &ft =~ 'markdown\|somethingelse'
    if &ft =~ 'go'
        return
    endif

  set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
endfunction
au bufenter * call DefaultTabSettings()

" misc
autocmd filetype py,c,haskell,groovy set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

" assembly
au bufenter *.asm,*.S,*.s set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

" do not expand tabs
au bufenter *.cfg set tabstop=2 softtabstop=0 expandtab! shiftwidth=2 smarttab

" end custom tab settings
" ------------------------


" spell checking for latex files (de-AT)
"
autocmd BufRead,BufNewFile *.tex setlocal spell spelllang=de_at

" -----------------
" set ft
autocmd BufRead,BufNewFile config-* set ft=sshconfig
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
" remove trailing whitespace

fun! StripTrailingWhitespace()
    " Don't strip on these filetypes
    " pattern to use:
    "
    "if &ft =~ 'markdown\|somethingelse'

    if &ft =~ 'markdown'
        return
    endif
    %s/\s\+$//e
endfun

autocmd BufWritePre * call StripTrailingWhitespace()
" -----------------


" -------------------------
" create directory if it does not exist
augroup Mkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END
" -------------------------

" -----------------
" case insensitive search
"set ignorecase
"set smartcase    " but become case sensitive if you type uppercase characters
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
" ncm2 tips

" ####
" TIPS
  " suppress the annoying 'match x of y', 'The only match' and 'Pattern not
  " found' messages
  set shortmess+=c

  " CTRL-C -> ESC
  inoremap <c-c> <ESC>
  " jj -> ESC
  inoremap jj <ESC>


  if has("nvim")
    " Use <TAB> to select the popup menu:
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  endif
" ####
"
" -----------------------


" remap PageUp to C-a
"nnoremap <C-a>  <C-b>

" do not jump to next line when lines are wrapped
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk
" disable help
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" disable arrow keys in all modes
nnoremap <up> <NOP>
nnoremap <down> <NOP>
nnoremap <left> <NOP>
nnoremap <right> <NOP>

inoremap <up> <NOP>
inoremap <down> <NOP>
inoremap <left> <NOP>
inoremap <right> <NOP>

vnoremap <up> <NOP>
vnoremap <down> <NOP>
vnoremap <left> <NOP>
vnoremap <right> <NOP>


" window management
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


" base64 encoding and decoding
vnoremap <leader>d64 y:let @"=system('base64 -d', @")<cr>gvP
vnoremap <leader>e64 y:let @"=system('base64 -w0', @")<cr>gvP



" set shorcut for tagbar plugin
nmap <f8> :TagbarToggle<cr>
" set path to tags file
set tags=.git/tags


" --------------------------------------------------
" vimscript functions not dependend on plugins start

" -------------------
" textobj indentation
onoremap <silent>ai :<C-U>cal <SID>IndTxtObj(0)<CR>
onoremap <silent>ii :<C-U>cal <SID>IndTxtObj(1)<CR>
vnoremap <silent>ai :<C-U>cal <SID>IndTxtObj(0)<CR><Esc>gv
vnoremap <silent>ii :<C-U>cal <SID>IndTxtObj(1)<CR><Esc>gv

function! s:IndTxtObj(inner)
  let curline = line(".")
  let lastline = line("$")
  let i = indent(line(".")) - &shiftwidth * (v:count1 - 1)
  let i = i < 0 ? 0 : i
  if getline(".") !~ "^\\s*$"
    let p = line(".") - 1
    let nextblank = getline(p) =~ "^\\s*$"
    while p > 0 && ((i == 0 && !nextblank) || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner)) || (nextblank && !a:inner))))
      -
      let p = line(".") - 1
      let nextblank = getline(p) =~ "^\\s*$"
    endwhile
    normal! 0V
    call cursor(curline, 0)
    let p = line(".") + 1
    let nextblank = getline(p) =~ "^\\s*$"
    while p <= lastline && ((i == 0 && !nextblank) || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner)) || (nextblank && !a:inner))))
      +
      let p = line(".") + 1
      let nextblank = getline(p) =~ "^\\s*$"
    endwhile
    normal! $
  endif
endfunction
" -------------------

" -----------------------------------
" prepend and append separating lines

function! AppendSeparator()
  normal mlyy}kp^v$r-xxgclk'l
endfunction
function! PrependSeparator()
  normal yyP^v$r-xxgclj
endfunction

nmap <leader>sa  :call AppendSeparator()<cr>
nmap <leader>sp  :call PrependSeparator()<cr>
" -----------------------------------


" -------------------------------
function! DeleteCharAtEndOfLine()
  normal! mz$x`z
endfunction

nnoremap <leader>d  :call DeleteCharAtEndOfLine()<cr>:silent! call repeat#set("\<leader>d", -1)<cr>
" -------------------------------


" copy clipboard to no-name register
nmap <leader>gr :let @"=@+<cr>
" copy no-name register to clipboard
nmap <leader>gR :let @+=@"<cr>

" Delete to Black Hole Register | Delete to Blackhole Register | Delete into the Void
" normal mode; combine with any textobject
nnoremap _d "_d
nnoremap _x "_x
" visual mode
vnoremap _d "_d<cr>
vnoremap _x "_x<cr>


" remap jump to line of mark to jump to pos
function! JumpToPos()
  let s:mark = nr2char(getchar())
  execute 'normal! `' . s:mark
endfunction
nnoremap ' :call JumpToPos()<cr>

" ---------------------------------------------------------------------
let s:replacement = ''  " global so last replacement will be remembered
function! s:ReplaceCharAtEndOfLine(isRepeat)
  if ! a:isRepeat
    let s:replacement = nr2char(getchar())
  endif
  execute 'normal! mz$r' . s:replacement . '`z'
  silent! call repeat#set("\<plug>ReplaceCharAtEndOfLineRepeat")
endfunction

nnoremap <silent> <plug>ReplaceCharAtEndOfLineRepeat :<c-u>call <sid>ReplaceCharAtEndOfLine(1)<cr>
nnoremap <silent> <plug>ReplaceCharAtEndOfLine :<c-u>call <sid>ReplaceCharAtEndOfLine(0)<cr>
nmap <leader>R <plug>ReplaceCharAtEndOfLine
" ---------------------------------------------------------------------


" ---------------------------------------------------------------------
let s:append_val = ''  " global so last append_val will be remembered
function! s:AppendCharAtEndOfLine(isRepeat)
  if ! a:isRepeat
    let s:append_val = nr2char(getchar())
  endif
  execute 'normal! mz$a' . s:append_val . '`z'
  silent! call repeat#set("\<plug>AppendCharAtEndOfLineRepeat");
endfunction

nnoremap <silent> <plug>AppendCharAtEndOfLineRepeat :<c-u>call <sid>AppendCharAtEndOfLine(1)<cr>
nnoremap <silent> <plug>AppendCharAtEndOfLine :<c-u>call <sid>AppendCharAtEndOfLine(0)<cr>
nmap <leader>sA <plug>AppendCharAtEndOfLine
" ---------------------------------------------------------------------

" vimscript functions not dependend on plugins end
" --------------------------------------------------




filetype plugin on
call plug#begin('~/.vim/plugged')
"    'github_user/repo_name'


Plug 'tpope/vim-vinegar'  " improve vim's netrw

Plug 'tpope/vim-afterimage'  " edit ICO, PNG, and GIF, PDFs and macos plists

" -----------------
" vim-commentary
Plug 'tpope/vim-commentary'

" custom comment strings
autocmd FileType firejail setlocal commentstring=#\ %s
" -----------------

Plug 'majutsushi/tagbar'

" tmux-resurrect dependency (do :mksession automatically...)
Plug 'tpope/vim-obsession'

Plug 'mileszs/ack.vim'
" replace ack by ag
let g:ackprg = 'ag --vimgrep'


" -----------------------------------
" coc language server

" Use <c-space> to trigger completion.
if has('nvim')
  Plug 'neoclide/coc.nvim'

  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
" -----------------------------------


Plug 'luochen1990/rainbow'
" :RainbowToggle
let g:rainbow_active = 0

" TODO: vim-endwise or vim-fish causes end statements to outdent all the way
" if ft=fish
"
Plug 'dag/vim-fish'
Plug 'vim-syntastic/syntastic'
Plug 'tpope/vim-endwise'

Plug 'tweekmonster/local-indent.vim'  " highlight indentation with vertical colored line
autocmd FileType yaml,markdown LocalIndentGuide +hl -cc

Plug 'christoomey/vim-sort-motion'  " type gs then the rest of your text objects & motions

" --------------------------------
" vim tmux runner settings
Plug 'christoomey/vim-tmux-runner'

" for Python and other languages with syntactic whitespace
let g:VtrStripLeadingWhitespace = 0
let g:VtrClearEmptyLines = 0
let g:VtrAppendNewline = 0
" --------------------------------

Plug 'glts/vim-magnum'  " dependency for vim-radical
Plug 'glts/vim-radical'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'  " e.g. ds" to delete surrounding quotes ; ysTEXTOBJECT'  to surround TEXTOBJECT with ' ; cs"' to change " to '
Plug 'tpope/vim-repeat'  " support native repeat operation '.' for plugins that implement tpope/vim-repeat





Plug 'inkarkat/vim-ingo-library'  " dependency for vim-mark and vim-ReplaceWithRegister
Plug 'inkarkat/vim-visualrepeat'  " dependency for vim-ReplaceWithRegister
" -----------------
" vim-mark
"
" to highlight a word under your cursor do: <leader>m
" to remove all highlights do: :MarkClear
"
Plug 'inkarkat/vim-mark'
let g:mwDefaultHighlightingPalette = 'extended'
" -----------------
Plug 'inkarkat/vim-ReplaceWithRegister'


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
  if has("nvim")
    autocmd BufEnter * call ncm2#enable_for_buffer()

    " IMPORTANT: :help Ncm2PopupOpen for more information
    set completeopt=noinsert,menuone,noselect
  endif


  " -----------------------
  " tmux-complete settings
  "
  Plug 'wellle/tmux-complete.vim' " vim completions from other tmux panes (used by ncm2)
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

  " ncm2 end
  " --------------


  " -----------------------------------
  "  semshi - semantic python highlighting start
  Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

  function CustomSemshiHighlightingColor()
    hi semshiLocal           ctermfg=209 guifg=#55c186
    hi semshiGlobal          ctermfg=214 guifg=#fc6620
    hi semshiImported        ctermfg=214 guifg=#eaac27 cterm=bold gui=bold
    hi semshiParameter       ctermfg=75  guifg=#55c186
    hi semshiParameterUnused ctermfg=117 guifg=#15d3b3 cterm=underline gui=underline
    hi semshiFree            ctermfg=218 guifg=#ffafd7
    hi semshiBuiltin         ctermfg=207 guifg=#ba16ba
    hi semshiAttribute       ctermfg=49  guifg=#00ffaf
    hi semshiSelf            ctermfg=249 guifg=#b2b2b2
    hi semshiUnresolved      ctermfg=226 guifg=#000000 guibg=#f94d75 cterm=underline gui=underline
    hi semshiSelected        ctermfg=231 guifg=#000000 ctermbg=161 guibg=#f0e8a5

    hi semshiErrorSign       ctermfg=231 guifg=#000000 ctermbg=160 guibg=#d70000
    hi semshiErrorChar       ctermfg=231 guifg=#000000 ctermbg=160 guibg=#d70000
    sign define semshiError text=E> texthl=semshiErrorSign
  endfunction
  autocmd FileType python call CustomSemshiHighlightingColor()


  "  semshi - semantic python highlighting end
  " -----------------------------------

  Plug 'flazz/vim-colorschemes'
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
endif

call plug#end()

