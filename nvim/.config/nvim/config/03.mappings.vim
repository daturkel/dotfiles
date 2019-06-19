" use `m` as a 'cut' function
nnoremap m d
xnoremap m d
nnoremap mm dd
nnoremap M D
" remap enter to clear highlighting
nnoremap <CR> :noh<CR>
" don't use Ex mode, use Q for formatting
map Q gq
" remaps c-u to allow undo recover from accidental c-u
inoremap <C-U> <C-G>u<C-U>
" we use C-I for indent guides, so let's use C-O for go to next jump
nnoremap <C-P> <C-I>
" better split management
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" toggle checkboxes in markdown
function Check()
    let l:line=getline('.')
    let l:curs=winsaveview()
    if l:line=~?'\s*-\s*\[\s*\].*'
        keepjumps s/\[\s*\]/[.]/
    elseif l:line=~?'\s*-\s*\[\.\].*'
        keepjumps s/\[.\]/[x]/
    elseif l:line=~?'\s*-\s*\[x\].*'
        keepjumps s/\[x\]/[ ]/
    endif
    call winrestview(l:curs)
endfunction

autocmd FileType markdown nnoremap <silent> - :call Check()<CR>

"move to the split in the direction shown, or create a new split
nnoremap <silent> <C-h> :call WinMove('h')<cr>
nnoremap <silent> <C-j> :call WinMove('j')<cr>
nnoremap <silent> <C-k> :call WinMove('k')<cr>
nnoremap <silent> <C-l> :call WinMove('l')<cr>

function! WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr())
    if (match(a:key,'[jk]'))
      wincmd v
    else
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction
