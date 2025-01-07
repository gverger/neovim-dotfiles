return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- We'd like this plugin to load first out of the rest
    config = true,   -- This automatically runs `require("luarocks-nvim").setup()`
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('render-markdown').setup({
        render_modes = { 'n', 'c', 'i' },
        heading = {
          enabled = true,
          sign = false,
          position = 'overlay',
          width = 'full',
        },
        code = {
          enabled = true,
          sign = false,
        },
        bullet = {
          icons = { "•" }
        },
        checkbox = {
          position = "overlay",
        }
      })
    end,
  },
  {
    'nvim-neorg/neorg',
    -- build = ":Neorg sync-parsers",
    dependencies = {
      -- "nvim-lua/plenary.nvim",
      "luarocks.nvim",
      'nvim-treesitter/nvim-treesitter',
    },
    ft = "norg",
    config = function()
      require("neorg").setup(
        {
          load = {
            ["core.defaults"] = {}, -- Loads default behaviour
            ["core.concealer"] = {
              config = {
                icon_preset = "basic",
                icons = {
                  todo = {
                    pending = { icon = "󰼛" }
                  },
                  code_block = {
                    conceal = true,
                    content_only = false,
                  },
                },
              }
            },
            ["core.dirman"] = { -- Manages Neorg workspaces
              config = {
                workspaces = {
                  notes = "~/norg/notes",
                  entretiens = "~/norg/entretiens"
                },
                default_workspace = "notes",
              },
            },
            ["core.completion"] = {
              config = {
                engine = "nvim-cmp",
              },
            },
            ["core.keybinds"] = {
              config = {
                hook = function(keybinds)
                  keybinds.map_event("norg", "i", "<M-O>", "core.itero.previous-iteration")
                  keybinds.map_event("norg", "i", "<M-o>", "core.itero.next-iteration")
                end,
              }
            },
          },
        })
    end,
  },
  -- 'nvim-orgmode/orgmode',
  'kaarmu/typst.vim',
  {
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    version = '1.*',
    config = function()
      require 'typst-preview'.setup {}
    end,
  },
}
