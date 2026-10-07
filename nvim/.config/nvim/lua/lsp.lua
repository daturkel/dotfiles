local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local e = function(desc) return vim.tbl_extend("force", opts, { desc = desc }) end

    vim.keymap.set("n", "gd",         vim.lsp.buf.definition,     e("Go to definition"))
    vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,    e("Go to declaration"))
    vim.keymap.set("n", "grr",        require("telescope.builtin").lsp_references, e("References"))
  end,
})

require("lsp_signature").setup({ hint_enable = false, handler_opts = { border = "none" } })

-- nvim-lspconfig supplies the per-server defaults (lsp/*.lua); mason-lspconfig installs
-- the servers and calls vim.lsp.enable() for each one
vim.lsp.config("*", { capabilities = capabilities })
vim.lsp.config("gopls", { settings = { gopls = { usePlaceholders = true } } })

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "jsonls", "yamlls", "marksman" },
  automatic_enable = true,
})
-- gopls comes from `go install golang.org/x/tools/gopls@latest` (~/go/bin), not mason:
-- mason's registry currently pins a gopls version that `go install` rejects
vim.lsp.enable("gopls")

vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "\u{f057}",  --
      [vim.diagnostic.severity.WARN]  = "\u{f071}",  --
      [vim.diagnostic.severity.INFO]  = "\u{f05a}",  --
      [vim.diagnostic.severity.HINT]  = "\u{f0eb}",  --
    },
  },
})

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

local severity_hl = {
  [vim.diagnostic.severity.ERROR] = "DiagnosticError",
  [vim.diagnostic.severity.WARN]  = "DiagnosticWarn",
  [vim.diagnostic.severity.INFO]  = "DiagnosticInfo",
  [vim.diagnostic.severity.HINT]  = "DiagnosticHint",
}
-- echo the diagnostic under the cursor; multi-line messages are flattened and truncated
-- to the available width so they never trigger the hit-enter prompt
vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local lnum = cursor[1] - 1
    local col  = cursor[2]
    for _, d in ipairs(vim.diagnostic.get(0, { lnum = lnum })) do
      if col >= d.col and col <= (d.end_col or d.col) then
        local msg = d.message:gsub("%s*\n%s*", " ")
        local width = vim.v.echospace - 1
        if vim.fn.strdisplaywidth(msg) > width then
          msg = vim.fn.strcharpart(msg, 0, width - 1) .. "…"
        end
        vim.api.nvim_echo({{ msg, severity_hl[d.severity] or "DiagnosticWarn" }}, false, {})
        return
      end
    end
    vim.api.nvim_echo({}, false, {})
  end,
})

local _hover = vim.lsp.buf.hover
vim.lsp.buf.hover = function()
  _hover({ max_height = 20, max_width = 80 })
end
