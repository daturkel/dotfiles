"" lightline
" general lightline config
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'active': {
    \   'right': [['lineinfo'],
    \             ['percent'],
    \             ['filetype' ]]
    \ },
    \ }
" hide --insert-- message
set noshowmode
