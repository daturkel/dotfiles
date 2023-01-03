vim.cmd([[
let g:wiki_root = '~/Documents/wiki'

let g:wiki_filetypes = ['md']

let g:wiki_map_link_create = 'Create'
let g:wiki_map_create_page = 'Create'
function Create(text) abort
  let lowered = tolower(a:text)
  let no_spaces = substitute(lowered, '\s\+', '-', 'g')
  let no_symbols = substitute(no_spaces, "[!?\\\.']", '', 'g')
  let no_quotes = substitute(no_symbols, '"', '', 'g')
  return no_quotes
endfunction

let g:wiki_link_target_type = 'md'
let g:wiki_link_extension = '.md'

let g:wiki_write_on_nav = 1

nmap <silent> <c-b> <plug>(wiki-index)
nnoremap <silent> <c-t> :e ~/Documents/wiki/todo.md<CR>
nmap <silent> <c-n> <plug>(wiki-open)
]])
