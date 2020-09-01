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
set termguicolors "Enable true colors
filetype plugin indent on
syntax on
au FileType perl set filetype=prolog

" keybinds
let mapleader="§"

nnoremap <silent> <leader>? :WhichKey '§'<CR>

call plug#begin('~/.local/share/nvim/plugged/')
  Plug 'neoclide/coc.nvim', {
    \ 'branch': 'release',
    \ 'do': { -> #coc#util#install() }
  \}
  Plug 'jiangmiao/auto-pairs'
  Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
  Plug 'honza/vim-snippets'
  Plug 'christoomey/vim-tmux-navigator' 
  Plug 'whatyouhide/vim-gotham'
  
  " Haskell
  Plug 'neovimhaskell/haskell-vim'
  Plug 'sbdchd/neoformat'
call plug#end()

" Reload config when saved
augroup vimrchook
    au!
    autocmd bufwritepost $MYVIMRC source $MYVIMRC
augroup END

colorscheme gotham

