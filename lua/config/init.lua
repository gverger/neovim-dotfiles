local M = {}

---@class ConfigOptions
M.defaults = {
}

---@type ConfigOptions
M.options = {
}

---@param options? ConfigOptions
function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, options or {})

  require('config.treesitter').setup()
  require('config.telescope').setup()
  require('config.notes').setup()
  require('config.notifications').setup()
  require('config.dap').setup()
  require('config.lsp').setup()

  require('config.windows').setup()

  require('config.styling').setup()
end

return M
