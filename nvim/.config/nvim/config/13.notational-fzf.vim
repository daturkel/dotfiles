" search paths
let g:nv_search_paths = ['~/Notes']
" short file paths
let g:nv_use_short_pathnames = 1
" open N-FZF
nnoremap <silent> <localleader>n :NV<CR>
" open new notes in main window
let g:nv_create_note_window = 'e'
" ignore the archive folder
let g:nv_ignore_pattern = ['**/archive/*']
