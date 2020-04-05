set autoindent
set number relativenumber
set showmode
set encoding=UTF-8
set hlsearch
set numberwidth=1
set tabstop=2
set softtabstop=2
set shiftwidth=2
set noexpandtab
set updatetime=200
filetype plugin indent on
syntax on

" keybinds
let mapleader="§"

"coc format
nnoremap <leader>F :call CocAction('format')<CR>

" coc refactor
nmap <leader>qf <Plug>(coc-fix-current)

call plug#begin('~/.local/share/nvim/plugged/')
	" coc
	Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':CocInstall coc-python coc-json coc-prettier'}

	" haskell
	Plug 'neovimhaskell/haskell-vim'
call plug#end()

" Reload config when saved
augroup vimrchook
	au!
	autocmd bufwritepost $MYVIMRC source $MYVIMRC
augroup END

