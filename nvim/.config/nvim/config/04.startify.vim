"" startify
" make the area below startify screen match the theme
autocmd User Startified 
    \ highlight! link NonText Normal |
    \ highlight! NonText guifg=#242424
" startify header
let g:ascii = [
            \'   ____  ___  ______   ________ ___ ',
            \'  / __ \/ _ \/ __ \ | / / / __ `__ \',
            \' / / / /  __/ /_/ / |/ / / / / / / /',
            \'/_/ /_/\___/\____/\___/_/_/ /_/ /_/ ',
            \]
let g:startify_custom_header =
            \ map(g:ascii, '"   ".v:val')
