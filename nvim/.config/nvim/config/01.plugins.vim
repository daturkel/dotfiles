function! DoRemote(arg)
    UpdateRemotePlugins
endfunction

call plug#begin('~/.config/nvim_plugins')
    " start-page for vim
    Plug 'mhinz/vim-startify'
    " needed for some remote plugins
    Plug 'mhinz/neovim-remote'
    " color schemes
    Plug 'rafi/awesome-vim-colorschemes'
    " better sql syntax file
    Plug 'shmup/vim-sql-syntax'
    " comment current line with `gcc`; visual mode with `gc`
    Plug 'tpope/vim-commentary' 
    " better `.` for repeating last commend
    Plug 'tpope/vim-repeat'
    " minimal statusline
    Plug 'itchyny/lightline.vim'
    " latex-related stuff
    Plug 'lervag/vimtex'
    " python syntax linter
    Plug 'ambv/black'
    " deletion operations don't use the yank register
    Plug 'svermeulen/vim-cutlass'
    " TOML syntax
    Plug 'cespare/vim-toml'
    " COC completion
    Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
call plug#end()
