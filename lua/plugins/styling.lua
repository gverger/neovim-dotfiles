return {
  {
    'folke/noice.nvim',
    config = function()
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
          bottom_search = false,         -- use a classic bottom cmdline for search
          command_palette = false,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true,        -- add a border to hover docs and signature help
        },
        messages = {
          enabled = false,
          view_search = false,
          view = "mini",
        },
        cmdline = {
          enabled = false,
          view = "cmdline"
        },
        routes = {
          {
            filter = { find = "LSP attached:" },
            view = 'mini',
          },
          {
            filter = { find = "No information available" },
            opts = { skip = true },
          },
          -- {
          --   view = "mini",
          --   filter = { event = "msg_showmode" },
          -- },
          {
            filter = { find = "Publish Diagnostics" },
            opts = { skip = true },
          },
          {
            filter = { find = "Validate documents" },
            opts = { skip = true },
          },
          {
            filter = {
              any = {
                { event = "msg_show", kind = "confirm" },
                { event = "msg_show", kind = "confirm" },
              },
            },
            opts = { view = 'confirm' },
          },
          {
            -- skip "file written" messages
            filter = { event = "msg_show", kind = '' },
            opts = { skip = true },
          },
          -- {
          --   filter = { find = "<node" },
          --   opts = { stop = true },
          -- },
          {
            filter = { find = "multiple different client offset_encodings" },
            opts = { skip = true },
          },
          {
            filter = { kind = "confirm_sub" },
            opts = { skip = 'false' },
          },
        },
      })
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  }
}
