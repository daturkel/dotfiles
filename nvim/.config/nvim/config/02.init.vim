" tell vim where to find python (can't use ~/ alias here for some reason)
let g:python_host_prog='${py2_loc}'
let g:python3_host_prog='${py3_loc}'

" Must be early
let maplocalleader = ","

"" better windowing
set hidden

"" behavior
" scroll padding 5 lines
set so=5
" scroll to next row for wrapped lines
nnoremap j gj
nnoremap k gk
" break lines at spaces
set linebreak
" >> and << move text 4 spaces
set shiftwidth=4
" tabs are just spaces 
set expandtab
" tabs are 4 columns wide
set tabstop=4
" but html and css should be two spaces
autocmd Filetype html setlocal ts=2 sw=2 sts=2
autocmd Filetype css setlocal ts=2 sw=2 sts=2
autocmd Filetype scss setlocal ts=2 sw=2 sts=2
" pressing tab in insert mode is 4 spaces
set softtabstop=4
" autoread outside changes
set autoread
" integrate OS and vim clipboard
set clipboard=unnamedplus
" enable mouse
set mouse=a
" 700 lines of history
set history=700
" don't be case sensitive when searching
set ignorecase
" but do be case sensitive once an upper case letter is used
set smartcase
" don't automatically assume line after comment is also a comment
au FileType * setlocal formatoptions-=cro
" return to last edit position when opening files
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
" strip trailing whitespace for python and sql
autocmd FileType py,sql autocmd BufWritePre <buffer> %s/\s\+$//e
" wildmenu with tab; fullmode
set wildchar=<Tab> wildmode=full
" horizontal splits below
set splitbelow

"" appearance
" line numbers
set number
" highlight current line
set cursorline
" set colorscheme
syntax enable
set termguicolors
colorscheme wombat256mod
" show matching brackets
set showmatch

"" terminal
" escape leaves terminal mode, also leaves fzf
if has("nvim")
  au TermOpen * tnoremap <Esc> <c-\><c-n>
  au FileType fzf tunmap <Esc>
endif
" enter insert mode when entering terminal
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert
" no spellcheck in terminal please!
au TermOpen * setlocal nospell
