local M = {}

local utils = require('config.utils')

function M.setup()
  if not utils.has_plug('noice.nvim') then
    vim.notify('noice is not installed', 'error')
    return
  end

  require("noice").setup({
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = {
        enabled = true,
      },
      progress = {
        enabled = false,
      },
    },
    cmdline = {
      enabled = false,
    },
    messages = {
      enabled = false,
    },
    presets = {
      lsp_doc_border = true
    },
    routes = {
      {
        filter = { find = "No information available" },
        opts = { stop = true },
      }
    },
  })

  if utils.has_plug('telescope.nvim') then
    require("telescope").load_extension("noice")
  end
end

return M
