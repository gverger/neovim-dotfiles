local M = {}

local utils = require('config.utils')

function M.setup()
  if not utils.has_plug('nvim-lint') then
    vim.notify('nvim-lint plugin not installed', 'error')
    return
  end

  require('lint').linters_by_ft = {
    -- markdown = { 'vale', 'proselint' },
    typst = { 'vale', 'proselint' },
    sh = { 'shellcheck', },
    -- python = { 'pylint', },
    html = { 'tidy' },
    java = { 'checkstyle' },
    dockerfile = { 'hadolint' },
    norg = { 'vale', 'proselint' }
  }

  local vale = require('lint.linters.vale')
  table.insert(vale.args, '--config=/home/gverger/.local/share/vale/.vale.ini')

  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })
end

return M
