local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { noremap = true, silent = true, buffer = bufnr }
    local e = function(desc) return vim.tbl_extend("force", opts, { desc = desc }) end

    vim.keymap.set("n", "gd",         vim.lsp.buf.definition,     e("Go to definition"))
    vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,    e("Go to declaration"))
    vim.keymap.set("n", "gr",         require("telescope.builtin").lsp_references, e("References"))
    vim.keymap.set("n", "gi",         vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K",          vim.lsp.buf.hover,          opts)
    vim.keymap.set("n", "<leader>r",  vim.lsp.buf.rename,         e("Rename"))
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,    e("Code action"))
    vim.keymap.set("n", "<leader>o",  function()
      require("telescope.builtin").lsp_document_symbols()
    end, e("Symbols"))
  end,
})

require("lsp_signature").setup({ toggle_key = "<C-s>", hint_enable = false, handler_opts = { border = "none" } })

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "gopls", "jsonls", "yamlls", "marksman" },
  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup({ capabilities = capabilities })
    end,
    ["gopls"] = function()
      require("lspconfig").gopls.setup({
        capabilities = capabilities,
        settings = { gopls = { usePlaceholders = true } },
      })
    end,
  },
})

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "\u{f057}",  --
      [vim.diagnostic.severity.WARN]  = "\u{f071}",  --
      [vim.diagnostic.severity.INFO]  = "\u{f05a}",  --
      [vim.diagnostic.severity.HINT]  = "\u{f0eb}",  --
    },
  },
})

vim.keymap.set("n", "[g", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]g", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

local severity_hl = {
  [vim.diagnostic.severity.ERROR] = "DiagnosticError",
  [vim.diagnostic.severity.WARN]  = "DiagnosticWarn",
  [vim.diagnostic.severity.INFO]  = "DiagnosticInfo",
  [vim.diagnostic.severity.HINT]  = "DiagnosticHint",
}
vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local lnum = cursor[1] - 1
    local col  = cursor[2]
    local diags = vim.diagnostic.get(0, { lnum = lnum })
    for _, d in ipairs(diags) do
      if col >= d.col and col <= (d.end_col or d.col) then
        local hl = severity_hl[d.severity] or "DiagnosticWarn"
        vim.api.nvim_echo({{ d.message, hl }}, false, {})
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
