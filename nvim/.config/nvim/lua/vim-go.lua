vim.cmd([[
" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0

autocmd FileType go map <localleader>b <Plug>(go-fmt)

let g:go_doc_popup_window = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

let g:go_auto_type_info = 1

let g:go_echo_go_info=0
]])
