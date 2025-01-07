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
    opts = {
      use_default_keymaps = false,
      keymaps = {
        ["_"] = "actions.open_cwd",
        ["-"] = "actions.parent",
        ["<C-r>"] = "actions.refresh",
        ["<CR>"] = "actions.select",
        ["g."] = "actions.toggle_hidden",
        ["g?"] = "actions.show_help",
        ["q"] = "actions.close",
        ["<C-v>"] = function()
          require('oil.actions').select_vsplit.callback()
          require('oil.actions').close.callback()
        end,
      },
      skip_confirm_for_simple_edits = true,
      view_options = {
        hidden = true
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
    'ggandor/leap.nvim',
    config = function()
      -- require("leap").add_default_mappings()
      require("leap").opts.highlight_unlabeled_phase_one_targets = true
      vim.keymap.set({ "n", "x", "o" }, 's', '<Plug>(leap-forward)', { silent = true, desc = "Leap forward", noremap = true })
      vim.keymap.set({ "n", "x", "o" }, 'S', '<Plug>(leap-backward)', { silent = true, desc = "Leap backward", noremap = true })
      vim.keymap.set("n", 'gs', '<Plug>(leap-from-window)', { silent = true, desc = "Leap from window", noremap = true })
    end
  },
}
