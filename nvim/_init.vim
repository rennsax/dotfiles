" keymap
let mapleader=" "
inoremap jj <Esc>
nnoremap <silent> <Leader>n :nohl<CR>
nnoremap <silent> <M-u> :nohl<CR>
" only highlight, not remove the cursor
" nnoremap <silent> g* :let @/ = expand("<cword>")<CR>:set hlsearch<CR>
nnoremap <M-d> g^dg$g^
nnoremap <Up> gk
nnoremap <Down> gj
xnoremap Y "+y
nnoremap Y "+y
nnoremap <Leader>p "*p

" custom text-object for numerical values
function! Numbers()
    call search('\d\([^0-9\.]\|$\)', 'cW')
    normal v
    call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap in :<C-u>call Numbers()<CR>
onoremap in :normal vin<CR>

" indent
set autoindent expandtab shiftround
set shiftwidth=4
set smarttab
set tabstop=4

" search
set hlsearch
set ignorecase "ic
set incsearch "is
set smartcase "scs

" text rendering
set scrolloff=3 "so
set sidescrolloff=5 "siso
syntax on
set wrap

" UI
set laststatus=2 "display the status bar
set ruler "48,80
set tabpagemax=50
set cursorline cursorcolumn
set number relativenumber
set noerrorbells
set mouse=
set title

" code folding
set foldmethod=indent
set nofoldenable

" others
set autoread
set backspace=indent,eol,start
set confirm
set hidden
set wildignore+=.pyc,.swp
set nrformats=bin,hex
