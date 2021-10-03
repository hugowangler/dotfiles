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
set updatetime=100
set colorcolumn=80
set hidden
set termguicolors "Enable true colors
set mouse=a
set spelllang=en
filetype plugin indent on
syntax on
au FileType perl set filetype=prolog

" keybinds
let mapleader="§"

" Spell checker
nnoremap <silent> <F11> :set spell!<cr>
inoremap <silent> <F11> <C-O>:set spell!<cr>

nnoremap <leader>sv :source $MYVIMRC<CR>

" WhichKey
nnoremap <silent> <leader>? :WhichKey '§'<CR>

" NERDTree
map <leader>e :NERDTreeToggle<CR>

call plug#begin('~/.local/share/nvim/plugged/')
  Plug 'neoclide/coc.nvim', {
    \ 'branch': 'release',
    \ 'do': { -> #coc#util#install() }
  \}
  Plug 'jiangmiao/auto-pairs'
  Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
  Plug 'honza/vim-snippets'
  Plug 'christoomey/vim-tmux-navigator' 
  Plug 'tpope/vim-surround'
  Plug 'vim-test/vim-test'
  Plug 'tpope/vim-commentary'

  "colorscheme
  Plug 'joshdick/onedark.vim'

  " Syntax highlighting
  Plug 'leafgarland/typescript-vim'
  Plug 'peitalin/vim-jsx-typescript'
  "Plug 'Yggdroot/indentLine'
  Plug 'jparise/vim-graphql'
  " Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

  "git
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'

  "Airline
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  "TmuxLine
  Plug 'edkolev/tmuxline.vim'

  "CtrlP
  Plug 'ctrlpvim/ctrlp.vim'

  "NerdTree
  Plug 'preservim/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'ryanoasis/vim-devicons'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

  " Haskell
  Plug 'neovimhaskell/haskell-vim'
  Plug 'sbdchd/neoformat'
call plug#end()

" Reload config when saved
augroup vimrchook
    au!
    autocmd bufwritepost $MYVIMRC source $MYVIMRC
augroup END

autocmd BufEnter *.ts set filetype=typescript
"autocmd BufEnter *.tsx set filetype=typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx
autocmd BufEnter *.tsx,*.jsx set filetype=typescript.tsx

colorscheme onedark
"highlight Cursorline guibg=Grey15
"highlight ColorColumn guibg=Grey15

" Python nvim virtualenv
let g:python3_host_prog='/home/hugo/.pyenv/versions/py3nvim/bin/python'
