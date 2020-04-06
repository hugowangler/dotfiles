set autoindent
set number relativenumber
set showmode
set encoding=UTF-8
set hlsearch
set numberwidth=1
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set updatetime=200
filetype plugin indent on
syntax on

" keybinds
let mapleader="§"

nnoremap <silent> <leader> :WhichKey '§'<CR>

call plug#begin('~/.local/share/nvim/plugged/')
    Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':CocInstall coc-python coc-json coc-prettier'}
    Plug 'neovimhaskell/haskell-vim'
    Plug 'jiangmiao/auto-pairs'
    Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
call plug#end()

" Reload config when saved
augroup vimrchook
    au!
    autocmd bufwritepost $MYVIMRC source $MYVIMRC
augroup END

