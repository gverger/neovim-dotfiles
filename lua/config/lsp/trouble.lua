local M = {}

local utils = require('config.utils')

function M.setup()
  if not utils.has_plug('trouble.nvim') then
    vim.notify('missing plugin trouble.nvim', 'error')
  end

  require("trouble").setup {
    modes = {
      buf_diagnostics = {
        mode = "diagnostics", -- inherit from diagnostics mode
        filter = function(items)
          local buf_id = vim.fn.bufnr()
          local severity = vim.diagnostic.severity.HINT
          for _, item in ipairs(items) do
            if item.buf == buf_id then
              severity = math.min(severity, item.severity)
            end
          end
          return vim.tbl_filter(function(item)
            return item.severity == severity and item.buf == buf_id
          end, items)
        end,
      }
    },
  }

  utils.noremap("n", "<leader>ee", ":Trouble buf_diagnostics toggle focus=true<CR>")
  utils.noremap("n", "<leader>el", ":Trouble diagnostics toggle<CR>")
end

return M
