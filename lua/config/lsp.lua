local M = {}

function M.setup()
  require('config.lsp.mason').setup()
  require('config.lsp.lspconfig').setup()
  require('config.lsp.trouble').setup()
  require('config.lsp.lsp_lines').setup()
  require('config.lsp.lsp-format').setup()
  require('config.lsp.nvim-lint').setup()
  require('config.lsp.styling').setup()
  require('config.lsp.mappings').setup()
end

return M
