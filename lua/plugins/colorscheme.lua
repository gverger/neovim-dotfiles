return {
  { "savq/melange-nvim" },
  {
    "zenbones-theme/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    -- you can set set configuration options here
    config = function()
      vim.g.zenbones_darken_comments = 65
      vim.g.zenbones_darkness = "stark"
      vim.cmd.colorscheme('zenbones')
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          vim.api.nvim_set_hl(0, '@lsp.mod.readonly.java', {})
        end
      })

      vim.cmd([[
      autocmd ColorScheme * hi LspReferenceRead term=standout gui=standout
      autocmd ColorScheme * hi LspReferenceText term=standout gui=standout
      autocmd ColorScheme * hi LspReferenceWrite term=standout gui=standout
      autocmd ColorScheme * hi LspCodeLens guifg=#c1a78e gui=italic
      autocmd ColorScheme * hi LspCodeLensSeparator guifg=#c1a78e gui=italic
      autocmd ColorScheme * hi DiagnosticHintWithBg guibg=#202322 guifg=#6A9589
      autocmd ColorScheme * hi DiagnosticWarnWithBg guibg=#2f241a guifg=#FF9E3B
      autocmd ColorScheme * hi DiagnosticErrorWithBg guibg=#2d1717 guifg=#E82424
      autocmd ColorScheme * hi DiagnosticInfoWithBg guibg=#202123 guifg=#658594

      autocmd ColorScheme * hi DiagnosticError guibg=none guifg=#C73E1D
      autocmd ColorScheme * hi DiagnosticFloatingError guibg=none guifg=#C73E1D
      autocmd ColorScheme * hi DiagnosticSignError guibg=none guifg=#C73E1D
      autocmd ColorScheme * hi DiagnosticWarn guibg=none guifg=#F18F01
      ]])
    end
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000, -- load it first
    config = function()
      -- require('kanagawa').setup({
      --   compile = false,
      --   undercurl = false,
      --   keywordStyle = { italic = false },
      --   statementStyle = { bold = false },
      --   -- functionStyle = { fg = "#a292a3" },
      --   colors = {
      --     theme = {
      --       all = {
      --         ui = { bg_gutter = "none" },
      --         syn = { parameter = "none" },
      --       }
      --     }
      --   },
      --   overrides = function(colors)
      --     local theme = colors.theme
      --     return {
      --       NormalFloat = { bg = "none" },
      --       FloatBorder = { bg = "none" },
      --       FloatTitle = { bg = "none" },
      --
      --       -- Save an hlgroup with dark background and dimmed foreground
      --       -- so that you can use it where your still want darker windows.
      --       -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
      --       NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
      --
      --       -- Popular plugins that open floats will link to NormalFloat by default;
      --       -- set their background accordingly if you wish to keep them dark and borderless
      --       LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
      --       MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
      --     }
      --   end,
      -- })
      --
      -- vim.api.nvim_create_autocmd('ColorScheme', {
      --   callback = function()
      --     vim.api.nvim_set_hl(0, '@lsp.mod.readonly.java', {})
      --   end
      -- })
      --
      -- vim.cmd([[
      --   autocmd ColorScheme * hi LspReferenceRead term=standout gui=standout
      --   autocmd ColorScheme * hi LspReferenceText term=standout gui=standout
      --   autocmd ColorScheme * hi LspReferenceWrite term=standout gui=standout
      --   autocmd ColorScheme * hi LspCodeLens guifg=#c1a78e gui=italic
      --   autocmd ColorScheme * hi LspCodeLensSeparator guifg=#c1a78e gui=italic
      --   autocmd ColorScheme * hi DiagnosticHintWithBg guibg=#202322 guifg=#6A9589
      --   autocmd ColorScheme * hi DiagnosticWarnWithBg guibg=#2f241a guifg=#FF9E3B
      --   autocmd ColorScheme * hi DiagnosticErrorWithBg guibg=#2d1717 guifg=#E82424
      --   autocmd ColorScheme * hi DiagnosticInfoWithBg guibg=#202123 guifg=#658594
      --
      --   autocmd ColorScheme * hi DiagnosticError guibg=none guifg=#C73E1D
      --   autocmd ColorScheme * hi DiagnosticFloatingError guibg=none guifg=#C73E1D
      --   autocmd ColorScheme * hi DiagnosticSignError guibg=none guifg=#C73E1D
      --   autocmd ColorScheme * hi DiagnosticWarn guibg=none guifg=#F18F01
      -- ]])
    end
  }
}
