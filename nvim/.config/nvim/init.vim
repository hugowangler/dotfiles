set autoindent
set number relativenumber
set showmode
set encoding=UTF-8
set hlsearch
set numberwidth=1
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set updatetime=200
set hidden
filetype plugin indent on
syntax on

" keybinds
let mapleader="§"

nnoremap <silent> <leader>? :WhichKey '§'<CR>

" Panes
noremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

call plug#begin('~/.local/share/nvim/plugged/')
    Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':CocInstall coc-python coc-json coc-prettier coc-snippets'}
    Plug 'jiangmiao/auto-pairs'
    Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
    Plug 'honza/vim-snippets'
    Plug 'christoomey/vim-tmux-navigator' 
    
    " Haskell
    Plug 'neovimhaskell/haskell-vim'
    Plug 'sbdchd/neoformat'
call plug#end()

" Reload config when saved
augroup vimrchook
    au!
    autocmd bufwritepost $MYVIMRC source $MYVIMRC
augroup END

