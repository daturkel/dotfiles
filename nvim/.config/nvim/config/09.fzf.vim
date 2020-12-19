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

" search files in this directory 
nnoremap <silent> <localleader>f :Files<CR>
nnoremap <silent> <localleader><localleader>f :Files!<CR>
" search git files
nnoremap <silent> <localleader>g :GFiles<CR>
nnoremap <silent> <localleader><localleader>g :GFiles!<CR>
" search recent files
nnoremap <silent> <localleader>h :History<CR>
nnoremap <silent> <localleader><localleader>h :History!<CR>
" search buffers shortcut
nnoremap <silent> <localleader>m :Buffers<CR>

command! -bang WikiPages 
  \ call fzf#vim#files('~/Documents/wiki', 
  \ fzf#vim#with_preview({'options': ['--prompt','Wiki> ']},'up:60%','ctrl-/'), 
  \ <bang>0)
nnoremap <silent> <localleader>w :WikiPages<CR>
nnoremap <silent> <localleader><localleader>w :WikiPages!<CR>
command! -bang -nargs=* WikiLines
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \  fzf#vim#with_preview({'dir':'~/Documents/wiki/', 'options': ['--prompt','WikiLines> ']},'up:60%','ctrl-/'),
  \   <bang>0)
nnoremap <silent> <localleader>W :WikiLines<CR>
nnoremap <silent> <localleader><localleader>W :WikiLines!<CR>

" search ripgrep shortcut
command! -bang -nargs=* CRg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \  fzf#vim#with_preview('up:60%','ctrl-/'),
  \   <bang>0)
nnoremap <silent> <localleader>r :CRg<CR>
nnoremap <silent> <localleader>R :CRg!<CR>
