local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "numToStr/Comment.nvim", lazy = false, config = function() require("Comment").setup() end },
  { "tpope/vim-repeat" },
  { "svermeulen/vim-cutlass" },
  { "cespare/vim-toml" },
  { "godlygeek/tabular" },
  { "preservim/vim-markdown" },
  { "tpope/vim-fugitive" },
  { "fatih/vim-go" },
  { "lervag/wiki.vim" },
  { "lervag/vimtex", ft = "tex" },
  { "mhinz/vim-startify" },
  { "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "ruff_format" },
          go = { "gofmt" },
        },
        -- ruff auto-discovers pyproject.toml config walking up from the file
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "python", "go" },
        callback = function(ev)
          vim.keymap.set("n", "<localleader>b", function()
            require("conform").format({ bufnr = ev.buf })
          end, { buffer = ev.buf, desc = "Format buffer" })
        end,
      })
    end
  },
  { "nvim-lualine/lualine.nvim",
    config = function()
      local function venv()
        local v = os.getenv("VIRTUAL_ENV")
        return v and v:match("[^\\/]+$") or ""
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
          lualine_c = { "FugitiveHead" },
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
    end
  },
  { "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      local highlight = { "CursorColumn", "Whitespace" }
      require("ibl").setup({
        enabled = false,
        indent = { highlight = highlight, char = "" },
        whitespace = { highlight = highlight, remove_blankline_trail = false },
        scope = { enabled = false },
      })
      vim.keymap.set("n", "<C-i>", ":IBLToggle<CR>", { silent = true, desc = "Toggle indent guides" })
    end
  },
  { "pacha/vem-dark", priority = 1000 },
  -- LSP
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  { "ray-x/lsp_signature.nvim" },
  -- completion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "asiryk/auto-hlsearch.nvim", config = function()
      require("auto-hlsearch").setup()
    end
  },
  { "folke/which-key.nvim", config = function()
      vim.opt.timeout = true
      vim.opt.timeoutlen = 500
      require("which-key").setup({ plugins = { spelling = { enabled = true } } })
    end
  },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
})
