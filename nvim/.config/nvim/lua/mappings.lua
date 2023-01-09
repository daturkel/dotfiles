-- use `m` as a 'cut' function
vim.keymap.set({'n', 'x'},'m','d')
vim.keymap.set('n', 'mm', 'dd')
vim.keymap.set('n', 'M', 'D')

-- don't use Ex more, use Q for formatting
vim.keymap.set({'n', 'v', 'o'}, 'Q', 'gq', {remap = true})

-- we use C-I for indent guides, so let's use C-P for go to next jump
vim.keymap.set("n", "<C-P>", "<C-I>")

-- better split management
vim.keymap.set('n', '<C-J>', '<C-W><C-J>')
vim.keymap.set('n', '<C-K>', '<C-W><C-K>')
vim.keymap.set('n', '<C-L>', '<C-W><C-L>')
vim.keymap.set('n', '<C-H>', '<C-W><C-H>')

-- move to the split in the direction shown, or create a new split
vim.keymap.set('n', '<C-h>', ":call WinMove('h')<cr>", {silent = true})
vim.keymap.set('n', '<C-j>', ":call WinMove('j')<cr>", {silent = true})
vim.keymap.set('n', '<C-k>', ":call WinMove('k')<cr>", {silent = true})
vim.keymap.set('n', '<C-l>', ":call WinMove('l')<cr>", {silent = true})
vim.cmd([[
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
]])

-- toggle checkboxes in markdown with -
vim.cmd([[
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
]])
