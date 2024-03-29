return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = {
          "lua",
          "c",
          "vim",
          "vimdoc",
          "java",
          "python",
          "c_sharp",
          "ruby",
          "bash",
          "markdown",
          "markdown_inline",
          "regex",
        },
        indent = {
          enable = false,
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          disable = function(lang, buf) -- disable for large files
            local max_filesize = 10 * 1024 * 1024 -- 10 MB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            return ok and stats and stats.size > max_filesize
          end,
        },
        incremental_selection = {
          enable = false,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["ib"] = "@block.inner",
              ["ae"] = "@custom_expression.outer",
            },
            selection_modes = {
              ['@custom_expression.outer'] = 'V',
              ['@function.outer'] = 'v',
              ['@class.outer'] = 'V',
            },
            include_surrounding_whitespace = true,
          }
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
      }
    end,
  },
  {
    event = "BufEnter",
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require 'treesitter-context'.setup {
        enable = false,   -- Enable this plugin (Can be enabled/disabled later via commands)
        mode = 'topline', -- Line used to calculate context. Choices: 'cursor', 'topline'
      }
      vim.cmd([[
        autocmd ColorScheme * hi TreesitterContext guibg=#444444
      ]])
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    }
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = "BufEnter",
    lazy = true,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    }
  },
  -- 'chrisbra/csv.vim',
  'LnL7/vim-nix',
}
