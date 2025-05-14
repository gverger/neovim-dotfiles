local M = {}

local utils = require('config.utils')

function M.setup()
  vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticError"})
  vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
  vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
  vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

  vim.diagnostic.config({
    virtual_lines = false,
    signs = true,
    virtual_text = {
      current_line = true,
      source = false,
    },
    float = {
      source = false,
      border = 'rounded',
      focusable = false,
      scope = 'cursor',
    },
    update_in_insert = false,
    severity_sort = true,
  })

  -- vim.api.nvim_set_hl(0, '@lsp.mod.readonly', {}) -- readonly makes java colors flicker

  utils.noremap("", "<Leader>d", function() end)

  utils.noremap("", "<Leader>dl", function()
    local current = vim.diagnostic.config().virtual_lines
    if current then
      vim.diagnostic.config({ virtual_lines = false, virtual_text = { current_line = true, source = false} })
    else
      vim.diagnostic.config({ virtual_lines = true, virtual_text = false })
    end
  end)
end

return M
