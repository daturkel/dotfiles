let g:deoplete#enable_at_startup=1

" disable autocomplete by default
let b:deoplete_disable_auto_complete=1
let g:deoplete_disable_auto_complete=1

" no sources by default
let g:deoplete#sources = {}

" minimum pattern length
let g:min_pattern_length=2

" no deoplete for strings and comments
call deoplete#custom#source('_',
    \ 'disabled_syntaxes', ['Comment', 'String'])

" set deoplete python source to language client
call deoplete#custom#option('sources', {
    \ 'python': ['LanguageClient'],
    \})

" deoplete around symbols
call deoplete#custom#var('around', {
    \ 'mark_above': '[↑]',
    \ 'mark_below': '[↓]',
    \ 'mark_changes': '[~]'
    \ })

" close preview after completion
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
