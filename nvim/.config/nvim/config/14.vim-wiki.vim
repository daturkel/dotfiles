let g:wiki_root = '~/Documents/wiki'

let g:wiki_filetypes = ['md']

let g:wiki_map_link_create = 'Create'
let g:wiki_map_create_page = 'Create'
function Create(text) abort
  return substitute(tolower(a:text), '\s\+', '-', 'g')
endfunction

let g:wiki_link_target_type = 'md'
let g:wiki_link_extension = '.md'

let g:wiki_write_on_nav = 1

nmap <silent> <c-b> <plug>(wiki-index)
nnoremap <silent> <c-t> :e ~/Documents/wiki/todo.md<CR>
nmap <silent> <c-n> <plug>(wiki-open)
