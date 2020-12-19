let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:fzf_preview_window = ['up:60%', 'ctrl-/']

nnoremap <silent> <localleader>f :Files<CR>
nnoremap <silent> <localleader>g :GFiles<CR>
nnoremap <silent> <localleader>h :History<CR>
" search buffer lines shortcut
nnoremap <silent> <localleader>l :BLines<CR>
" search buffers shortcut
nnoremap <silent> <localleader>m :Buffers<CR>

command! -bang WikiPages 
  \ call fzf#vim#files('~/Documents/wiki', 
  \ fzf#vim#with_preview({'options': ['--prompt','Wiki> ']},'up:60%','ctrl-/'), 
  \ <bang>0)
nnoremap <silent> <localleader>p :WikiPages<CR>
nnoremap <silent> <localleader>P :WikiPages!<CR>
command! -bang -nargs=* WikiLines
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \  fzf#vim#with_preview({'options': ['--prompt','WikiLines> ']},'up:60%','ctrl-/'),
  \   <bang>0)
nnoremap <silent> <localleader>w :WikiLines<CR>
nnoremap <silent> <localleader>W :WikiLines!<CR>

" search ripgrep shortcut
command! -bang -nargs=* CRg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \  fzf#vim#with_preview('up:60%','ctrl-/'),
  \   <bang>0)
nnoremap <silent> <localleader>r :CRg<CR>
nnoremap <silent> <localleader>R :CRg!<CR>
