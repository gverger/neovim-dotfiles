return {
  -- {
  --   "m4xshen/hardtime.nvim",
  --   dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  --   opts = {}
  -- },
  {
    'stevearc/oil.nvim',
    keys = {
      { "-", "<cmd>Oil<CR>" }
    },
    lazy = false,
    opts = {
      use_default_keymaps = false,
      keymaps = {
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["-"] = { "actions.parent", mode = "n" },
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-l>"] = "actions.refresh",
        ["<C-r>"] = "actions.refresh",
        ["<C-v>"] = { "actions.select", opts = { vertical = true, close = true } },
        ["<CR>"] = "actions.select",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g?"] = { "actions.show_help", mode = "n" },
        ["q"] = "actions.close",
      },
      skip_confirm_for_simple_edits = true,
      view_options = {
        hidden = true
      },
    },
    dependencies = { { "nvim-mini/mini.icons", opts = {} }},
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        renderer = {
          group_empty = true
        },
      }
    end,
  },
  -- 'unblevable/quick-scope',
  {
    'Julian/vim-textobj-variable-segment',
    dependencies = {
      'thinca/vim-textobj-between',
    },
  },
  {
    'thinca/vim-textobj-between',
    dependencies = {
      'kana/vim-textobj-user',
    },
  },
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    config = function()
      -- require("leap").add_default_mappings()
      require("leap").opts.highlight_unlabeled_phase_one_targets = true
      vim.keymap.set({ "n", "x", "o" }, 's', '<Plug>(leap-forward)', { silent = true, desc = "Leap forward", noremap = true })
      vim.keymap.set({ "n", "x", "o" }, 'S', '<Plug>(leap-backward)', { silent = true, desc = "Leap backward", noremap = true })
      vim.keymap.set("n", 'gs', '<Plug>(leap-from-window)', { silent = true, desc = "Leap from window", noremap = true })
    end
  },
}
