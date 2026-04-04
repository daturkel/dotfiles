local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "tpope/vim-repeat" },
  { "svermeulen/vim-cutlass" },
  { "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
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
    end,
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
  { "ViViDboarder/wombat.nvim", priority = 1000, dependencies = { "rktjmp/lush.nvim" }, config = function()
      vim.cmd("colorscheme wombat_lush")
    end
  },
  { "Mofiqul/vscode.nvim", lazy = true },
  { "reobin/olive-crt.nvim", lazy = true },
  { "WTFox/jellybeans.nvim", lazy = true },
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
      require("nvim-treesitter").install({ "python", "go", "lua", "bash", "json", "yaml", "toml", "markdown", "markdown_inline" }):wait()
    end,
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
})
