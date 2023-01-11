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
  -- colorschemes
  use 'pacha/vem-dark'
  -- latex
  use 'lervag/vimtex'
  -- python formatting
  use 'psf/black'
  -- delete operations don't use the yank register
  use 'svermeulen/vim-cutlass'
  -- toml syntax
  use 'cespare/vim-toml'
  -- -- code completion
  use {'neoclide/coc.nvim', branch = 'release' }
  -- indent guides (tab to show)
  use 'nathanaelkane/vim-indent-guides'
  -- markdown
  use 'godlygeek/tabular'
  use 'preservim/vim-markdown'
  -- git
  use 'tpope/vim-fugitive'
  -- wiki
  use 'lervag/wiki.vim'
  -- golang
  use 'fatih/vim-go'
  -- keymap popup
  use {
    "folke/which-key.nvim",
      config = function()
        vim.cmd([[
          set timeout
          set timeoutlen=500
        ]])
        require("which-key").setup({plugins = { spelling = { enabled = true } } })
     end
  }
  -- Auto highlight/unhighlight search results
  use {
    "asiryk/auto-hlsearch.nvim",
      config = function()
        require("auto-hlsearch").setup()
      end
  }
  -- finder
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'fannheyward/telescope-coc.nvim'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
