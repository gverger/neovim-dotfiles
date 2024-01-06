return {
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter", -- load plugin on insert enter
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'FelipeLema/cmp-async-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'rcarriga/cmp-dap',
      {
        'saadparwaiz1/cmp_luasnip',
        dependencies = {
          'L3MON4D3/LuaSnip',
          'rafamadriz/friendly-snippets',
        },
      },
    },
    config = function()
      -- Setup nvim-cmp.
      local cmp = require 'cmp'
      local ls = require('luasnip')

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        enabled = function()
          return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        snippet = {
          expand = function(args)
            ls.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<C-l>'] = cmp.mapping(function(fallback)
            if ls.expand_or_jumpable() then
              ls.expand_or_jump()
            elseif cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-k>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif ls.jumpable(-1) then
              ls.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        experimental = {
          ghost_text = true,
        },

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'nvim_lua' },
          { name = 'async_path' },
          -- { name = 'orgmode' },
          { name = 'neorg' },
        }, {
          {
            name = 'buffer',
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            },
          },
        }),
        formatting = {
          format = require 'lspkind'.cmp_format({
            mode = "symbol_text",
            menu = ({
              buffer = "[buf]",
              nvim_lsp = "[lsp]",
              luasnip = "[snip]",
              nvim_lua = "[lua]",
              async_path = "[path]",
              -- orgmode = "[org]",
              nvim_lsp_signature_help = "[sig]",
            })
          }),
        },
        --    formatting = {
        --      format = require'lspkind'.cmp_format({with_text = false }),
        --    },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'async_path' },
          { name = 'cmdline' },
        }, {
          { name = 'buffer' },
        })
      })

      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        }
      })

      cmp.setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
        sources = {
          { name = 'dap' }, -- You can specify the `cmp_git` source if you were installed it.
        },
      })

      vim.keymap.set("i", "<c-u>", require "luasnip.extras.select_choice", { silent = true })
    end
  },
  {
    'L3MON4D3/LuaSnip',
    lazy = true,
    config = function()
      local ls = require('luasnip')

      vim.keymap.set({ "i", "s" }, "<c-j>", function() if ls.expandable() then ls.expand() end end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<c-l>", function() if ls.jumpable(1) then ls.jump(1) end end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<c-k>", function() if ls.jumpable(-1) then ls.jump(-1) end end, { silent = true })
      vim.keymap.set({ "i" }, "<c-h>", function() if ls.choice_active() then ls.change_choice(1) end end, { silent = true })

      require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
      require("luasnip.loaders.from_vscode").load() -- for friendly-snippets
      require("luasnip").filetype_extend("c_sharp", { "cs", "csharpdoc" })


      vim.keymap.set({ "n" }, "<leader><leader>s", function()
        require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets" })
        require("luasnip.loaders.from_vscode").load() -- for friendly-snippets
      end)

      vim.keymap.set({ "n" }, "<leader>se", require("luasnip.loaders").edit_snippet_files)

      local types = require("luasnip.util.types")

      ls.setup({
        update_events = "TextChanged,TextChangedI",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "<-- choose (<c-h>)", "Comment" } },
              hl_group = "GitSignsChangeLn",
            },
          },
        },
        ft_func = require("luasnip.extras.filetype_functions").from_pos_or_filetype,
        --    load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft({
        --      markdown = {"lua", "json", "mermaid", "ruby", "python", "bash", "java"}
        --    })
      })
      -- ls.filetype_set("cs", { "csharp" })
    end,
  }
}
