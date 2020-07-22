" no folds
let g:vim_markdown_folding_disabled = 1
" shrink toc if possible
let g:vim_markdown_toc_autofit = 1
" but not for code blocks
let g:vim_markdown_conceal_code_blocks = 0
" yaml frontmatter
let g:vim_markdown_frontmatter = 1
" open Toc
autocmd Filetype markdown nnoremap <silent> <localleader>j :Toch<cr>
" select from TOC and quit
autocmd FileType qf nnoremap <Space> <cr>:only<cr>
