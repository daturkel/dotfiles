"" black
" map <localleader>b to run black
autocmd FileType python map <localleader>b :Black<cr>
" point to virtual environment with black installed
let g:black_virtualenv = '${home_dir}.local/share/virtualenvs/neovim'
