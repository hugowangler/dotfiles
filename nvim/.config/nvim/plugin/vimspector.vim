nmap <Leader>dd :call vimspector#Launch()<CR>
nmap <Leader>de :call vimspector#Reset()<CR>
nmap <Leader>dgc :call vimspector#RunToCursor()<CR>
nmap <Leader>dc <Plug>VimspectorContinue
nmap <Leader>dbp <Plug>VimspectorToggleBreakpoint
nmap <Leader>dbcp <Plug>VimspectorToggleConditionalBreakpoint
nmap <Leader>dj <Plug>VimspectorStepOver
nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dk <Plug>VimspectorStepOut
nmap <Leader>di <Plug>VimspectorBalloonEval

let g:vimspector_sign_priority = {
  \    'vimspectorBP':         999,
  \    'vimspectorBPCond':     999,
  \    'vimspectorBPDisabled': 999,
  \    'vimspectorPC':         999,
  \ }

function s:DisableFolds()
  " Customise the terminal window size/position
  " For some reasons terminal buffers in Neovim have line numbers
  call win_gotoid( g:vimspector_session_windows.variables )
  set nofoldenable
  call win_gotoid( g:vimspector_session_windows.watches )
  set nofoldenable
  call win_gotoid( g:vimspector_session_windows.stack_trace )
  set nofoldenable
endfunction

augroup MyVimspectorUICustomistaion
  autocmd!
  autocmd User VimspectorUICreated call s:DisableFolds()
augroup END
