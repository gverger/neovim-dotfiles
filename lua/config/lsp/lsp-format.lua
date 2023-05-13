local M = {}

local utils = require('config.utils')

function M.setup()
  if not utils.has_plug('lsp-format.nvim') then
    vim.notify('lsp-format plugin not installed', 'error')
    return
  end

  require "lsp-format".setup {
    go = {
      {
        cmd = { "goimports -w" },
        tempfile_postfix = ".tmp"
      }
    },
    javascript = {
      { cmd = { "prettier -w", "./node_modules/.bin/eslint --fix" } }
    },
  }
end

return M

