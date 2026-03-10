set number relativenumber
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set updatetime=300
set colorcolumn=120
set spelllang=en
set signcolumn=yes

" keybinds
let mapleader=" "

nnoremap <leader>sv :source $MYVIMRC<CR>

" WhichKey
nnoremap <silent> <leader>? :WhichKey ' '<CR>

" NERDTree
map <leader>e :NERDTreeToggle<CR>

" fzf
nnoremap <C-p> :Files<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>/ :BLines<CR>
nnoremap <leader>fh :History<CR>

" Hide highlight using enter
nnoremap <silent> <cr> :noh<cr><cr>

call plug#begin('~/.local/share/nvim/plugged/')
    Plug 'jiangmiao/auto-pairs'
    Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
    Plug 'christoomey/vim-tmux-navigator' 
    Plug 'tpope/vim-surround'
    Plug 'vim-test/vim-test'

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    "colorscheme
    Plug 'folke/tokyonight.nvim'

    " git
    Plug 'tpope/vim-fugitive'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'lewis6991/gitsigns.nvim'

    "NerdTree
    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'ryanoasis/vim-devicons'

    Plug 'unblevable/quick-scope'
call plug#end()

" Reload config when saved
augroup vimrchook
    au!
    autocmd bufwritepost $MYVIMRC source $MYVIMRC
augroup END

colorscheme tokyonight-night

"Disable unused providers
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

"Python nvim virtualenv
let g:python3_host_prog='/Users/hugo/.venvs/py3nvim/bin/python'

lua << EOF
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr })
    vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr })
    vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr })
    vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr })
    vim.keymap.set('n', ']c', gs.next_hunk, { buffer = bufnr })
    vim.keymap.set('n', '[c', gs.prev_hunk, { buffer = bufnr })
  end
})
EOF
