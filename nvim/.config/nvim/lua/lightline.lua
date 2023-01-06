vim.cmd([[
function Venv()
    return matchstr($VIRTUAL_ENV,'[^\\/]*$')
endfunction
]])

-- hide "--insert--" message
vim.opt.showmode = false

vim.g.lightline = {
    colorscheme = 'wombat',
    active = {
        left = { 
            {'mode'},
            {'readonly', 'filename', 'modified'},
            {'branch'}
        },
        right = {
        {'percent'},
        {'filetype'},
        {'venv'}
    }
    },
    inactive = {
        left = {
            {'readonly', 'filename', 'modified'},
            {'branch'}
        },
        right = {
            {'percent'},
            {'filetype'},
            {'venv'}
        }
    },
    component_function = {
        branch = 'FugitiveHead',
        venv = 'Venv'
    }
}
