local M = {}

local utils = require('config.utils')

function M.setup()
  if not utils.has_plug('mason.nvim') then
    vim.notify('mason.nvim plugin not installed')
    return
  end

  require("mason").setup {}

  if not utils.has_plug('mason-lspconfig.nvim') then
    vim.notify('mason-lspconfig.nvim plugin not installed')
    return
  end

  require("mason-lspconfig").setup {
    ensure_installed = {
      "bashls",
      "docker_compose_language_service",
      "dockerls",
      "esbonio",
      "gopls",
      "gradle_ls",
      "html",
      "jdtls",
      "jsonls",
      "lemminx",
      "lua_ls",
      "marksman",
      "solargraph",
      "sourcery",
      "tsserver",
      "vimls",
    },
  }
end

return M
