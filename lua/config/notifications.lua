local M = {}

local utils = require('config.utils')

function M.setup()
  if not utils.has_plug('noice.nvim') then
    vim.notify('noice is not installed')
    return
  end

  if utils.has_plug('telescope.nvim') then
    require("telescope").load_extension("noice")
  end
end

return M
