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
