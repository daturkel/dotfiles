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
    let line=getline('.')
    if line=~?'\s*-\s*\[\s*\].*'
         s/\[\s*\]/[x]/
    elseif line=~?'\s*-\s*\[x\].*'
         s/\[x\]/[ ]/
    endif
endfunction

autocmd FileType markdown nnoremap - :call Check()<CR>
