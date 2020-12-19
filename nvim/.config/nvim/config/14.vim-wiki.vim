let g:wiki_root = '~/Documents/wiki'

let g:wiki_filetypes = ['md']

let g:wiki_map_link_create = 'MapCreate'
function MapCreate(text) abort
  return substitute(tolower(a:text), '\s\+', '-', 'g')
endfunction

let g:wiki_link_target_type = 'md'
let g:wiki_link_extension = '.md'

let g:wiki_write_on_nav = 1
