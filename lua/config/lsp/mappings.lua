local M = {}

-- local utils = require('config.utils')

function M.setup()
  vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.format({async = true}) end, { noremap = true, silent = true })
  vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, { noremap = true, silent = true })
  vim.keymap.set("n", "<c-$>", vim.lsp.buf.definition, { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })
  vim.keymap.set("n", "L", vim.lsp.buf.document_highlight, { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>ch", vim.lsp.buf.code_action, { noremap = true, silent = true })
  vim.keymap.set("v", "<leader>ch", vim.lsp.buf.code_action, { noremap = true, silent = true })
end

return M
