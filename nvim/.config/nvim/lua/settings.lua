vim.g.maplocalleader = ','
vim.g.mapleader = ' '

-- python interpreter paths (substituted by deploy script)
vim.g.python_host_prog = '${py2_loc}'
vim.g.python3_host_prog = '${py3_loc}'

-- don't show partial commands in command bar
vim.opt.showcmd = false

-- ── Behavior ──────────────────────────────────────────────────────────────────

vim.opt.modeline = false        -- disable dangerous modeline
vim.opt.scrolloff = 5           -- scroll padding
vim.opt.linebreak = true        -- break lines at spaces
vim.opt.shiftwidth = 4
vim.opt.expandtab = true        -- tabs are spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.history = 700
vim.opt.ignorecase = true
vim.opt.smartcase = true        -- case sensitive once an upper case letter is used
vim.opt.formatoptions:append("or")  -- automatic comment continuation
vim.opt.wildmode = "full"
vim.opt.splitbelow = true
vim.opt.signcolumn = "number"
vim.opt.updatetime = 150
vim.opt.shortmess:append("c")   -- don't show completion menu messages
vim.opt.conceallevel = 0

-- ── Appearance ────────────────────────────────────────────────────────────────

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.showmatch = true        -- show matching brackets

-- ── Netrw ─────────────────────────────────────────────────────────────────────

vim.g.netrw_liststyle = 3       -- tree mode
vim.g.netrw_banner = 0

-- ── Filetype-specific tab widths ──────────────────────────────────────────────

local tw = vim.api.nvim_create_augroup("TabWidth", { clear = true })
for _, ft in ipairs({ "html", "markdown", "css", "scss", "htmldjango", "jinja", "lua" }) do
  vim.api.nvim_create_autocmd("FileType", {
    group = tw,
    pattern = ft,
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.softtabstop = 2
    end,
  })
end

-- pressing o continues bulleted list in markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function() vim.opt_local.formatoptions:append("o") end,
})

-- yaml
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  pattern = { "*.yaml", "*.yml" },
  callback = function()
    vim.opt_local.filetype = "yaml"
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- strip trailing whitespace for python and sql on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.py", "*.sql" },
  callback = function() vim.cmd("%s/\\s\\+$//e") end,
})

-- return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.fn.line("'\"")
    if mark > 1 and mark <= vim.fn.line("$") then
      vim.cmd("normal! g`\"")
    end
  end,
})

-- create parent directories on save if they don't exist
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(ev)
    vim.fn.mkdir(vim.fn.fnamemodify(ev.match, ":p:h"), "p")
  end,
})

-- ── Terminal ──────────────────────────────────────────────────────────────────

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = true })
    vim.opt_local.spell = false
  end,
})

-- fzf overrides the Esc mapping
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fzf",
  callback = function() vim.keymap.del("t", "<Esc>", { buffer = true }) end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  pattern = "term://*",
  callback = function() vim.cmd("startinsert") end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "term://*",
  callback = function() vim.cmd("stopinsert") end,
})

