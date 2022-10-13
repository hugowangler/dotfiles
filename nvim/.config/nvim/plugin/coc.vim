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


" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

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

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Python
nmap <leader>si :CocCommand python.sortImports<CR>

" nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> K :call ShowDocumentation()<CR>


" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
