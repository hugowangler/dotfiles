" coc-snippets
""""""""""""""""""""""
let g:coc_snippet_next = '<c-l>'
let g:coc_snippet_prev = '<c-h>'
let g:coc_global_extensions = [
			\ 'coc-tsserver',
			\ 'coc-json',
			\ 'coc-eslint',
			\ 'coc-prettier',
			\ 'coc-css',
			\ 'coc-html',
			\ 'coc-snippets',
			\ 'coc-yaml',
			\ 'coc-vimlsp',
			\ 'coc-go',
      \ 'coc-sh',
      \ 'coc-pyright',
      \ 'coc-docker',
      \ 'coc-prisma',
			\]

"To code navigatione <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

nnoremap <leader>F :call CocAction('format')<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt :call CocAction('jumpDefinition', 'botright vsplit')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-diagnostic-next)
nmap <silent> gp <Plug>(coc-diagnostic-prev)

nmap <leader>qf <Plug>(coc-fix-current)
nmap <leader>do <Plug>(coc-codeaction)
nmap <leader>rn <Plug>(coc-rename)

inoremap <silent><expr> <c-space> coc#refresh()

" Python
nmap <leader>si :CocCommand python.sortImports<CR>

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
