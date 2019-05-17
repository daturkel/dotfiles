" be sure to install coc-snippets, coc-python, and coc-json with :CocInstall

" Use tab to trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Navigate snippet placeholders with tab
let g:coc_snippet_next = "<Tab>"
let g_coc_snippet_prev = "<S-Tab>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfunction

" use control-space to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" use enter co confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" goto mappings
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gd <Plug>(coc-definition)

" use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if &filetype == 'vim'
        execute 'h '.expand('<cword>')
    else
        call CocActionAsync('doHover')
    endif
endfunction
