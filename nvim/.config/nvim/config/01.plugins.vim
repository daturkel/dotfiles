function! DoRemote(arg)
    UpdateRemotePlugins
endfunction

call plug#begin('~/.config/nvim_plugins')
    " start-page for vim
    Plug 'mhinz/vim-startify'
    " comment current line with `gcc`; visual mode with `gc`
    Plug 'tpope/vim-commentary' 
    " better `.` for repeating last commend
    Plug 'tpope/vim-repeat'
    " minimal statusline
    Plug 'itchyny/lightline.vim'
    " latex-related stuff
    Plug 'lervag/vimtex'
    Plug 'mhinz/neovim-remote' "also needed for tex
    " python syntax linter
    Plug 'psf/black', { 'branch': 'stable' }
    " deletion operations don't use the yank register
    Plug 'svermeulen/vim-cutlass'
    " TOML syntax
    Plug 'cespare/vim-toml'
    " COC completion
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " FZF
    Plug '/usr/local/opt/fzf'
    Plug 'junegunn/fzf.vim'
    " Indent guides
    Plug 'nathanaelkane/vim-indent-guides'
    " Richer markdown support
    Plug 'godlygeek/tabular'
    Plug 'plasticboy/vim-markdown'
    " Better objects for brackets, tags, quotes
    Plug 'tpope/vim-surround'
    " Git
    Plug 'tpope/vim-fugitive'
    " Wiki
    Plug 'lervag/wiki.vim'
    " vem dark theme
    Plug 'pacha/vem-dark'
    " Documentation generator
    Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
    " Go
    Plug 'fatih/vim-go'
call plug#end()
