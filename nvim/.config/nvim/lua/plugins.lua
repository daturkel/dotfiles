local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- start-page for vim
  use 'mhinz/vim-startify'
  -- comment current line with `gcc`; visual mode with `gc`
  use 'tpope/vim-commentary' 
  -- better `.` for repeating last commend
  use 'tpope/vim-repeat'
  -- minimal statusline
  use 'itchyny/lightline.vim'
  -- latex
  use 'lervag/vimtex'
  -- python formatting
  use 'psf/black'
  -- delete operations don't use the yank register
  use 'svermeulen/vim-cutlass'
  -- toml syntax
  use 'cespare/vim-toml'
  -- -- code completion
  use {'neoclide/coc.nvim', branch = "release"}
  -- -- lsp
  -- use 'neovim/nvim-lspconfig'
  -- -- lsp completion
  -- use 'hrsh7th/cmp-nvim-lsp'
  -- use 'hrsh7th/cmp-buffer'
  -- use 'hrsh7th/cmp-path'
  -- use 'hrsh7th/cmp-cmdline'
  -- use 'hrsh7th/nvim-cmp'
  -- use 'L3MON4D3/LuaSnip'
  -- use 'saadparwaiz1/cmp_luasnip'
  -- use 'ray-x/lsp_signature.nvim'
  -- fzf
  use { 'junegunn/fzf', run = ":call fzf#install()" }
  use { 'junegunn/fzf.vim' }
  -- indent guides (tab to show)
  use 'nathanaelkane/vim-indent-guides'
  -- markdown
  use 'godlygeek/tabular'
  use 'preservim/vim-markdown'
  -- git
  use 'tpope/vim-fugitive'
  -- wiki
  use 'lervag/wiki.vim'
  -- colorscheme
  use 'pacha/vem-dark'
  -- golang
  use 'fatih/vim-go'
  -- keymap popup
  use {
    "folke/which-key.nvim",
      config = function()
        vim.cmd([[
          silent set timeout
          silent set timeoutlen=500
        ]])
        require("which-key").setup({plugins = { spelling = { enabled = true } } })
     end
  }
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
