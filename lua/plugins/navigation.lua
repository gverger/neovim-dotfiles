return {
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
        ["v"] = function()
          require('oil.actions').select_vsplit.callback()
          require('oil.actions').close.callback()
        end,
      },
      view_options = {
        hidden = true
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
  },
}
