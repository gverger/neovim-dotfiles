local M = {}

local utils = require('config.utils')

function M.setup()
  if not utils.has_plug("lsp_lines.nvim") then
    vim.notify("lsp_lines.nvim is not installed", "error")
    return
  end

  local lsp_lines = require('lsp_lines')

  lsp_lines.setup()

  utils.noremap("", "<Leader>d", function()
  end, { desc = "cancel deletion on mistyping leader d" })

  utils.noremap("", "<Leader>dl", function()
    local current = vim.diagnostic.config().virtual_text
    if current then
      vim.diagnostic.config({ virtual_text = false })
    else
      vim.diagnostic.config({ virtual_text = { severity = "Error" } })
    end
    lsp_lines.toggle()
  end, { desc = "Toggle lsp_lines" })
end

return M
