local M = {}

local utils = require('config.utils')

function M.setup()
  if not utils.has_plug('trouble.nvim') then
    vim.notify('missing plugin trouble.nvim', 'error')
  end

  require("trouble").setup {
    mode = "document_diagnostics",
  }

  utils.noremap("n", "<leader>ee", ":TroubleToggle document_diagnostics<CR>")
  utils.noremap("n", "<leader>el", ":TroubleToggle workspace_diagnostics<CR>")
end

return M

