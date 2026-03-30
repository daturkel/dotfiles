local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "tpope/vim-commentary" },
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
  { "psf/black", ft = "python" },
  { "itchyny/lightline.vim" },
  { "nathanaelkane/vim-indent-guides" },
  { "pacha/vem-dark", priority = 1000 },
  { "neoclide/coc.nvim", branch = "release" },
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
  { "fannheyward/telescope-coc.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
})
