local M = {}

local function autocommands()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(a)
      vim.notify("LSP attached: " .. vim.lsp.get_client_by_id(a.data.client_id).name)
    end,
  })
end

function M.setup()
  autocommands()
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
