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

" search files with preview
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
" search files shortcut
nnoremap <silent> <localleader>f :Files<CR>

" search git files with preview
command! -bang -nargs=? -complete=dir GFiles
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)
" search git files shortcut
nnoremap <silent> <localleader>g :GFiles<CR>

" search history with preview
command! -bang -nargs=* Hist
  \ call fzf#vim#history(fzf#vim#with_preview())
" search history shortcut
nnoremap <silent> <localleader>h :Hist<CR>

" search buffer lines shortcut
nnoremap <silent> <localleader>l :BLines<CR>

" search buffers shortcut
nnoremap <silent> <localleader>m :Buffers<CR>

" search ripgrep shortcut
command! -bang -nargs=* CRg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:33%', '?'),
  \   <bang>0)
nnoremap <silent> <localleader>r :CRg<CR>
nnoremap <silent> <localleader>R :CRg!<CR>
