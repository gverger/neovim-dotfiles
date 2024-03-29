local M = {}

local utils = require('config.utils')

function M.setup()
  vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
  vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
  vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
  vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

  vim.diagnostic.config({
    virtual_lines = false,
    signs = true,
    virtual_text = false,
    float = {
      header = false,
      source = 'if_many',
      border = 'rounded',
      focusable = false,
    },
    update_in_insert = false,
    severity_sort = true,
  })

  -- vim.api.nvim_set_hl(0, '@lsp.mod.readonly', {}) -- readonly makes java colors flicker
end

return M
