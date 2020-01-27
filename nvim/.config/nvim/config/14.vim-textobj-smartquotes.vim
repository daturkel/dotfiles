" Use this plugin on markdown and plaintext files
" But don't auto-correct in plaintext
augroup textobj_quote
  autocmd!
  autocmd FileType markdown call textobj#quote#init()
  autocmd FileType text call textobj#quote#init({'educate': 0})
augroup END

" Replace straight quotes with curly ones
map <silent> <localleader>qc <Plug>ReplaceWithCurly
map <silent> <localleader>qs <Plug>ReplaceWithStraight

" With vim-surround, you can change surrounding chars to quotes with
" cs'q : 'abc' -> ‘abc’ 
