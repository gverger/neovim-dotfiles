local M = {}

local utils = require('config.utils')

function M.setup()
  if not utils.has_plug('noice.nvim') then
    vim.notify('noice is not installed')
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
        silence = true,
      },
      progress = {
        enabled = true,
      }
    },
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    messages = {
      enabled = true,
      view_search = false,
      view = "mini",
    },
    cmdline = {
      view = "cmdline"
    },
    routes = {
      {
        filter = { event = "msg_show", kind = "return_prompt" },
        opts = { skip = true },
      },
      {
        filter = { find = "No information available" },
        opts = { stop = true },
      },
      {
        view = "mini",
        filter = { event = "msg_showmode" },
      },
      {
        filter = { find = "Publish Diagnostics" },
        opts = { stop = true },
      },
      {
        filter = { find = "Validate documents" },
        opts = { stop = true },
      },
      {
        -- skip "file written" messages
        filter = { event = "msg_show", kind = '' },
        opts = { stop = true },
      },
      {
        filter = { find = "<node" },
        opts = { stop = true },
      },
    },
  })

  if utils.has_plug('telescope.nvim') then
    require("telescope").load_extension("noice")
  end
end

return M
