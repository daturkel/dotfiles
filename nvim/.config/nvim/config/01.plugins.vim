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
    " tab completion
    Plug 'ervandew/supertab'
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
    " language server support
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \ }
    " async completion
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    " fzf search
    Plug 'junegunn/fzf.vim'
    " TOML syntax
    Plug 'cespare/vim-toml'
call plug#end()
