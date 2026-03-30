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
  { "preservim/vim-markdown", config = function()
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_toc_autofit = 1
      vim.g.vim_markdown_conceal_code_blocks = 0
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_new_list_item_indent = 0
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.keymap.set("n", "<localleader>j", ":Toch<cr>", { silent = true, desc = "TOC" })
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "qf",
        callback = function()
          vim.keymap.set("n", "<Space>", "<cr>:only<cr>", { buffer = true })
        end,
      })
    end
  },
  { "tpope/vim-fugitive" },
  { "fatih/vim-go", config = function()
      vim.g.go_def_mapping_enabled = 0     -- gd handled by native LSP
      vim.g.go_gopls_enabled = 0           -- gopls handled by mason-lspconfig
      vim.g.go_doc_popup_window = 1
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_methods = 1
      vim.g.go_highlight_structs = 1
      vim.g.go_highlight_interfaces = 1
      vim.g.go_highlight_operators = 1
      vim.g.go_highlight_build_constraints = 1
      vim.g.go_def_mode = "gopls"
      vim.g.go_info_mode = "gopls"
      vim.g.go_auto_type_info = 1
      vim.g.go_echo_go_info = 0
    end
  },
  { "lervag/wiki.vim", enabled = false },
  { "lervag/vimtex", ft = "tex", config = function()
      vim.g.vimtex_compiler_progname = "nvr"
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_matchparen_enabled = 0
      vim.g.vimtex_compiler_latexmk = {
        options = { "-pdf", "-shell-escape", "-verbose", "-file-line-error", "-synctex=1", "-interaction=nonstopmode" }
      }
      vim.g.tex_flavor = "latex"
    end
  },
  { "mhinz/vim-startify" },
  { "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "ruff_format" },
          go = { "gofmt" },
        },
        format_on_save = { timeout_ms = 500 },
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
  { "pacha/vem-dark", priority = 1000, config = function()
      vim.cmd("colorscheme vem-dark")
      vim.g.vem_colors_italic = 1
    end
  },
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
  { "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter").install({ "python", "go", "lua", "bash", "json", "yaml", "markdown", "markdown_inline" }):wait()
    end,
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
})
