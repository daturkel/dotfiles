vim.opt.completeopt = { "menu", "menuone", "preview" }

local cmp = require("cmp")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif has_words_before() then cmp.complete()
      else fallback() end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      else fallback() end
    end,
    ["<CR>"]    = cmp.mapping.confirm({ select = true }),
    ["<C-b>"]   = cmp.mapping.scroll_docs(-4),
    ["<C-f>"]   = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"]   = cmp.mapping.abort(),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
  completion = { autocomplete = false },  -- manual trigger only (matches CoC behavior)
})
