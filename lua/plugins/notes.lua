return {
  {
    'nvim-neorg/neorg',
    build = ":Neorg sync-parsers",
    dependencies = {
      "nvim-lua/plenary.nvim",
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
}
