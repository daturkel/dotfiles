local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local e = function(desc) return vim.tbl_extend("force", opts, { desc = desc }) end

  vim.keymap.set("n", "gd",         vim.lsp.buf.definition,    e("Go to definition"))
  vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,   e("Go to declaration"))
  vim.keymap.set("n", "gr",         vim.lsp.buf.references,    e("References"))
  vim.keymap.set("n", "gi",         vim.lsp.buf.implementation, opts)
  -- press K twice to focus the hover window for scrolling
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>r",  vim.lsp.buf.rename,        e("Rename"))
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,   e("Code action"))
  vim.keymap.set("n", "<leader>o",  function()
    require("telescope.builtin").lsp_document_symbols()
  end, e("Symbols"))
end

require("lsp_signature").setup({ toggle_key = "<C-s>", hint_enable = false })

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "gopls", "jsonls", "yamlls" },
  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
    ["gopls"] = function()
      require("lspconfig").gopls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = { gopls = { usePlaceholders = true } },
      })
    end,
  },
})

vim.diagnostic.config({ virtual_text = false, signs = false })

vim.keymap.set("n", "[g", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]g", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

local _hover = vim.lsp.buf.hover
vim.lsp.buf.hover = function()
  _hover({ max_height = 20, max_width = 80 })
end
