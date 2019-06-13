"" lightline
" general lightline config
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'active': {
    \   'left': [['mode'],
    \            ['readonly','filename','modified'],
    \            ['branch']],
    \   'right': [['percent'],
    \             ['filetype'],
    \             ['venv']]
    \ },
    \ 'inactive': {
    \   'left': [['readonly','filename','modified'],
    \            ['branch']],
    \   'right': [['percent'],
    \             ['filetype'],
    \             ['venv']]
    \ },
    \ 'component_function': {
    \  'branch': 'Branch',
    \  'venv': 'Venv'
    \ },
    \ }
" hide --insert-- message
set noshowmode

function! Branch()
    let branch = fugitive#head()
    if branch != '' && &ft != 'startify'
        let response = branch
    else
        let response = ''
    endif
    return response
endfunction

function Venv()
    return matchstr($VIRTUAL_ENV,'[^\/]*$')
endfunction
