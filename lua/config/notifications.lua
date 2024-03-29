local M = {}

local utils = require('config.utils')

function M.setup()
  if not utils.has_plug('noice.nvim') then
    vim.notify('noice is not installed')
    return
  end

  -- require("telescope").load_extension("noice")
end

return M
