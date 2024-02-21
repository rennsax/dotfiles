" keymap
let mapleader=" "
inoremap jj <Esc>
nnoremap <silent> <Leader>n :nohl<CR>
nnoremap <silent> <M-u> :nohl<CR>
" only highlight, not remove the cursor
nnoremap <silent> g* :let @/ = expand("<cword>")<CR>:set hlsearch<CR>
" nnoremap <Leader>d dd
nnoremap <Leader>ek :vs $XDG_CONFIG_HOME/nvim/init.vim<CR>
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

if exists('g:vscode')
    " Workaround for gk/gj
    " See https://github.com/vscode-neovim/vscode-neovim/blob/68f056b4c9cb6b2559baa917f8c02166abd86f11/vim/vscode-code-actions.vim#L93-L95
    nmap <Up> gk
    nmap <Down> gj
    nnoremap <Leader>t :lua require('vscode-neovim').call('workbench.action.terminal.focus')<CR>
    nnoremap <Leader>h :lua require('vscode-neovim').action('editor.action.showHover')<CR>
    nnoremap <Leader>r :lua require('vscode-neovim').action('editor.action.refactor')<CR>
    nnoremap <Leader>o :lua require('vscode-neovim').call('clangd.switchheadersource')<CR>
    nnoremap <Leader><leader>t :lua require('vscode-neovim').call('editor.emmet.action.updateTag')<CR>
    nnoremap <Leader><leader>d :lua require('vscode-neovim').call('editor.action.peekDefinition')<CR>
    nnoremap <Leader><leader>r :lua require('vscode-neovim').call('editor.action.referenceSearch.trigger')<CR>
    nnoremap <Leader><C-h> :lua require('vscode-neovim').call('extension.dash.specific')<CR>
    nnoremap <Leader>m :lua require('vscode-neovim').call('bookmarks.toggle')<CR>
    nnoremap <Leader>f :lua require('vscode-neovim').call('workbench.explorer.fileView.focus')<CR>
endif

" auto source `init.vim`
augroup NVIMRC
    autocmd!
    autocmd BufWritePost init.vim source %
augroup END

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

if $NVIM_INSTALL_PLUGINS == 1
    lua require("rennsax.lazy")
endif
