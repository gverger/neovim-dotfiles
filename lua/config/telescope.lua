local M = {}

local utils = require('config.utils')

function M.setup()
  if not utils.has_plug('telescope.nvim') then
    vim.notify('telescope.nvim plugin not installed')
    return
  end

  local actions = require("telescope.actions")
  require("telescope").setup {
    defaults = {
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
      },
      dynamic_preview_title = true,
    },
    windblend = 50,
    pickers = {
      buffers = {
        sort_mru = true,
        sort_lastused = true,
      },
      tags = {
        only_sort_tags = true,
        show_line = false,
        layout_strategy = 'vertical',
        path_display = { "tail" },
      },
      current_buffer_fuzzy_find = {
        layout_strategy = 'vertical'
      },
      git_files = {
        disable_devicons = true,
      },
      find_files = {
        disable_devicons = true,
      },
      oldfiles = {
        disable_devicons = true,
      },
    },
  }
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('ui-select')

  utils.noremap("n", "<leader>rl", ":Telescope git_files<CR>")
  utils.noremap("n", "<leader>rl", ":Telescope git_files<CR>")
  utils.noremap("n", "<leader>rf", ":Telescope find_files<CR>")
  utils.noremap("n", "<leader>bl", ":Telescope buffers<CR>")
  utils.noremap("n", "<leader>hl", ":Telescope oldfiles<CR>")
  utils.noremap("n", "<leader>l", ":Telescope current_buffer_fuzzy_find<CR>")
  utils.noremap("n", "<leader>j", ":Telescope lsp_document_symbols<CR>")
  utils.noremap("n", "<leader>t", ":Telescope tags<CR>")
  utils.noremap("n", "<leader>gr", ":Telescope lsp_references<CR>")
  utils.noremap("n", "<leader>gd", ":Telescope lsp_definitions<CR>")
  utils.noremap("n", "<leader>gi", ":Telescope lsp_implementations<CR>")
  utils.noremap("n", "<leader>dt", ":Telescope dap commands<CR>")
end

return M
