local actions = require('telescope.actions')
local layout = require('telescope.actions.layout')

require("telescope").setup({
  defaults = {
    prompt_title = false,
    results_title = false,
    preview_title = false,
    layout_strategy = "center",
    sorting_strategy = "ascending",
    borderchars = {
      { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
      prompt = {"─", "│", " ", "│", '┌', '┐', "│", "│"},
      results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
    },
    previewer=false,
    layout_config = {
      center = {
        preview_cutoff = 1,
        height = function(_,_,max_lines)
          return math.min(max_lines, 12)
        end,
      },
    },
    preview = {
      msg_bg_fillchar = " ",
    },
    mappings = {
      i = {
        ['<C-p>'] = layout.toggle_preview,
        ['<Esc>'] = actions.close
      },
    },
  },
  extensions = {
    coc = {
      theme = 'ivy',
      prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
    },
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
  },
})
require('telescope').load_extension('coc')
require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<localleader>f', builtin.find_files, { desc = "Files", silent = true})
vim.keymap.set('n', '<localleader>g', builtin.git_files, { desc = "Git files", silent = true })
vim.keymap.set('n', '<localleader>l', builtin.current_buffer_fuzzy_find, { desc = "Lines", silent = true})
vim.keymap.set('n', '<localleader>m', builtin.buffers, { desc = "Buffers", silent = true })
vim.keymap.set('n', '<localleader>r', builtin.live_grep, { desc = "Grep", silent = true})
vim.keymap.set('n', '<localleader>h', builtin.oldfiles, { desc = "Recent files", silent = true})
vim.keymap.set('n', '<localleader>d', ':Telescope coc diagnostics<cr>', { desc = "Diagnostics", silent = true})
vim.keymap.set('n', '<localleader>s', ':Telescope coc document_symbols<cr>', { desc = "Symbols", silent = true})
vim.keymap.set('n', '<localleader>S', ':Telescope coc workspace_symbols<cr>', { desc = "Workspace symbols", silent = true})
