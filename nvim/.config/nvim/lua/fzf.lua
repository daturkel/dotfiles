vim.cmd([[
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
]])
vim.keymap.set('n', '<localleader>l', ':RG<CR>', {silent = true, desc='Lines'})

vim.keymap.set('n', '<localleader>f', ':Files<CR>', {silent = true, desc='Files'})
-- vim.keymap.set('n', '<localleader>F', ':Files!<CR>', {silent = true, desc='Files... (fullscreen)'})
vim.keymap.set('n', '<localleader>g', ':GFiles<CR>', {silent = true, desc='Git files'})
-- vim.keymap.set('n', '<localleader>G', ':GFiles!<CR>', {silent = true, desc='Git files (fullscreen)'})
vim.keymap.set('n', '<localleader>h', ':History<CR>', {silent = true, desc='Recent files'})
-- vim.keymap.set('n', '<localleader>H', ':History!<CR>', {silent = true, desc='Recent files (fullscreen)'})
vim.keymap.set('n', '<localleader>m', ':Buffers<CR>', {silent = true, desc='Buffers'})

vim.cmd([[
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

let g:fzf_preview_window = ['up:60%', 'ctrl-p']

command! -bang WikiPages 
  \ call fzf#vim#files('~/Documents/wiki', 
  \ fzf#vim#with_preview({'options': ['--prompt','Wiki> ']},'up:60%','ctrl-p'), 
  \ <bang>0)
nnoremap <silent> <localleader>w :WikiPages<CR>
" nnoremap <silent> <localleader><localleader>w :WikiPages!<CR>
command! -bang -nargs=* WikiLines
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \  fzf#vim#with_preview({'dir':'~/Documents/wiki/', 'options': ['--prompt','WikiLines> ']},'up:60%','ctrl-p'),
  \   <bang>0)
nnoremap <silent> <localleader>W :WikiLines<CR>
" nnoremap <silent> <localleader><localleader>W :WikiLines!<CR>
]])
