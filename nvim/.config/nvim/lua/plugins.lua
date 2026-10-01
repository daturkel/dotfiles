-- Plugins are managed by the built-in vim.pack (nvim 0.12+). Revisions are pinned in
-- nvim-pack-lock.json; update with :lua vim.pack.update()
local gh = function(repo) return "https://github.com/" .. repo end

-- build steps; must be registered before vim.pack.add so they fire on first install
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= "install" and kind ~= "update" then return end
    if name == "telescope-fzf-native.nvim" then
      vim.system({ "make" }, { cwd = ev.data.path }):wait()
    elseif name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  gh("tpope/vim-repeat"),
  gh("svermeulen/vim-cutlass"),
  gh("OXY2DEV/markview.nvim"),
  gh("tpope/vim-fugitive"),
  gh("lervag/vimtex"),
  gh("mhinz/vim-startify"),
  gh("stevearc/conform.nvim"),
  gh("nvim-lualine/lualine.nvim"),
  gh("lukas-reineke/indent-blankline.nvim"),
  -- colorschemes
  gh("rktjmp/lush.nvim"),
  gh("ViViDboarder/wombat.nvim"),
  gh("Mofiqul/vscode.nvim"),
  gh("reobin/olive-crt.nvim"),
  gh("WTFox/jellybeans.nvim"),
  -- LSP
  gh("mason-org/mason.nvim"),
  gh("mason-org/mason-lspconfig.nvim"),
  gh("neovim/nvim-lspconfig"),
  gh("ray-x/lsp_signature.nvim"),
  -- completion
  gh("hrsh7th/nvim-cmp"),
  gh("hrsh7th/cmp-nvim-lsp"),
  gh("hrsh7th/cmp-buffer"),
  gh("hrsh7th/cmp-path"),
  gh("asiryk/auto-hlsearch.nvim"),
  gh("folke/which-key.nvim"),
  gh("nvim-lua/plenary.nvim"),
  gh("nvim-telescope/telescope.nvim"),
  gh("nvim-telescope/telescope-fzf-native.nvim"),
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
})

vim.cmd("colorscheme wombat_lush")

require("markview").setup({
  preview = {
    modes = { "n", "c" },
  },
  markdown = {
    headings = {
      enable = true,
      shift_width = 0,
      heading_1 = { style = "label", sign = "", icon = "# ",  padding_right = " ", hl = "MarkviewHeading1" },
      heading_2 = { style = "label", sign = "", icon = "## ", padding_right = " ", hl = "MarkviewHeading2" },
      heading_3 = { style = "label", icon = "### ", padding_right = " ", hl = "MarkviewHeading3" },
      heading_4 = { style = "label", icon = "#### ", padding_right = " ", hl = "MarkviewHeading4" },
      heading_5 = { style = "label", icon = "##### ", padding_right = " ", hl = "MarkviewHeading5" },
      heading_6 = { style = "label", icon = "###### ", padding_right = " ", hl = "MarkviewHeading6" },
    },
    code_blocks = { sign = false },
    list_items = {
      shift_width = 2,
      marker_minus = { text = "•" },
      marker_plus  = { text = "•" },
      marker_star  = { text = "•" },
    },
  },
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<localleader>p", "<cmd>Markview Toggle<cr>", { buffer = true, desc = "Toggle markview" })
  end,
})

-- vimtex
vim.g.vimtex_compiler_progname = "nvr"
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_matchparen_enabled = 0
vim.g.vimtex_compiler_latexmk = {
  options = { "-pdf", "-shell-escape", "-verbose", "-file-line-error", "-synctex=1", "-interaction=nonstopmode" }
}
vim.g.tex_flavor = "latex"

-- formatting (ruff auto-discovers pyproject.toml config walking up from the file)
require("conform").setup({
  formatters_by_ft = {
    python = { "ruff_format" },
    go = { "goimports" },  -- goimports = gofmt + import organizing
  },
  format_on_save = { timeout_ms = 500 },
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "go" },
  callback = function(ev)
    vim.keymap.set("n", "<localleader>b", function()
      require("conform").format({ bufnr = ev.buf })
    end, { buffer = ev.buf, desc = "Format buffer" })
  end,
})

-- statusline
local function venv()
  local v = os.getenv("VIRTUAL_ENV")
  return v and v:match("[^\\/]+$") or ""
end
local function git_dirty()
  local file = vim.fn.expand("%:p")
  if file == "" then return "" end
  local result = vim.fn.system("git status --porcelain " .. vim.fn.shellescape(file) .. " 2>/dev/null")
  return (result ~= "" and vim.v.shell_error == 0) and "\u{f044}" or ""
end
require("lualine").setup({
  options = {
    theme = "wombat",
    icons_enabled = false,
    section_separators = "",
    component_separators = "|",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { { "filename", symbols = { modified = " -", readonly = " RO" } } },
    lualine_c = { { "FugitiveHead", separator = "" }, { git_dirty, padding = { left = 0, right = 1 } } },
    lualine_x = { "filetype", venv },
    lualine_y = { "percent" },
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = { { "filename", symbols = { modified = " -", readonly = " RO" } } },
    lualine_c = { "FugitiveHead" },
    lualine_x = { "filetype" },
    lualine_y = { "percent" },
    lualine_z = {},
  },
})

-- indent guides
local ibl_highlight = { "CursorColumn", "Whitespace" }
require("ibl").setup({
  enabled = false,
  indent = { highlight = ibl_highlight, char = "" },
  whitespace = { highlight = ibl_highlight, remove_blankline_trail = false },
  scope = { enabled = false },
})
vim.keymap.set("n", "<C-i>", ":IBLToggle<CR>", { silent = true, desc = "Toggle indent guides" })

require("auto-hlsearch").setup()

vim.opt.timeout = true
vim.opt.timeoutlen = 500
require("which-key").setup({ plugins = { spelling = { enabled = true } } })

-- parsers are installed async; no-op when already present
require("nvim-treesitter").install({ "python", "go", "lua", "bash", "json", "yaml", "toml", "markdown", "markdown_inline" })
