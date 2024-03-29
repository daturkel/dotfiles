vim.cmd([[
"" vimtex
let g:vimtex_compiler_progname='nvr'
let g:vimtex_view_method = 'skim'
let g:vimtex_matchparen_enabled = 0
let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-pdf',
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}
let g:tex_flavor = 'latex'
]])
