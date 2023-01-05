vim.cmd([[
" no folds
let g:vim_markdown_folding_disabled = 1
" shrink toc if possible
let g:vim_markdown_toc_autofit = 1
" no conceal for code blocks
let g:vim_markdown_conceal_code_blocks = 0
" yaml frontmatter
let g:vim_markdown_frontmatter = 1
" open Toc
autocmd Filetype markdown nnoremap <silent> <localleader>j :Toch<cr>
" select from TOC and quit
autocmd FileType qf nnoremap <Space> <cr>:only<cr>
" don't add indent to new list items
let g:vim_markdown_new_list_item_indent = 0
]])
