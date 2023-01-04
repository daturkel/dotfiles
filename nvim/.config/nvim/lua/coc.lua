function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}

-- Tab for completions
vim.keymap.set("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- use enter to confirm selection
vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use <c-space> to trigger completion
vim.keymap.set("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
vim.keymap.set("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

-- Show all diagnostics with space-a
vim.keymap.set("n", "<space>a", ":<C-u>CocList diagnostics<cr>", {silent = true, nowait = true})
-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

-- goto mappings
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", {silent = true})
vim.keymap.set("n", "gr", "<Plug>(coc-references)", {silent = true})

-- Update signature help on jump placeholder
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder"
})

vim.g.coc_global_extensions = {'coc-json', 'coc-snippets', 'coc-pyright', 'coc-yaml'}

-- Navigate snippet placeholders with tab
vim.g.coc_snippet_next = "<Tab>"
vim.g.coc_snippet_prev = "<S-Tab>"

vim.cmd([[
"" " ,b for formatting
"" nmap <localleader>b  <Plug>(coc-format)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" No coc suggestions for plaintext/markdown
autocmd FileType markdown,text let b:coc_suggest_disable = 1
]])
