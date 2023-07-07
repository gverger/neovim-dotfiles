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
    virtual_text = {
      severity = "Error"
    },
    float = {
      header = false,
      source = 'if_many',
      border = 'rounded',
      focusable = false,
    },
    update_in_insert = false,
    severity_sort = true,
  })

  vim.cmd([[
    autocmd ColorScheme * hi LspReferenceRead term=standout gui=underline
    autocmd ColorScheme * hi LspReferenceText term=standout gui=underline
    autocmd ColorScheme * hi LspReferenceWrite term=standout gui=underline
    autocmd ColorScheme * hi LspCodeLens guifg=#c1a78e gui=italic
    autocmd ColorScheme * hi LspCodeLensSeparator guifg=#c1a78e gui=italic
  ]])
end

return M
