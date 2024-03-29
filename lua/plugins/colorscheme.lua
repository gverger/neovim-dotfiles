return {
  -- {
  --   'rose-pine/neovim',
  --   name = 'rose-pine',
  --   priority = 1000,
  --   config = function()
  --     require('rose-pine').setup({
  --       styles = {
  --         italic = false,
  --       },
  --       highlight_groups = {
  --         Normal = {
  --           bg = "#181616",
  --         },
  --         Comment = { italic = true },
  --       }
  --     })
  --
  --     vim.api.nvim_create_autocmd('ColorScheme', {
  --       callback = function()
  --         vim.api.nvim_set_hl(0, '@lsp.mod.readonly.java', {})
  --       end
  --     })
  --
  --     vim.cmd([[
  --       set encoding=utf-8
  --       set ambiwidth=single
  --
  --       set t_ut=                " fix 256 colors in tmux http://sunaku.github.io/vim-256color-bce.html
  --
  --       if has("termguicolors")  " set true colors
  --         let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  --         let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  --       endif
  --       set termguicolors
  --       " colorscheme kanagawa-dragon
  --       colorscheme rose-pine
  --     ]])
  --   end,
  -- },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000, -- load it first
    config = function()
      require('kanagawa').setup({
        compile = false,
        undercurl = false,
        keywordStyle = { italic = false },
        statementStyle = { bold = false },
        -- functionStyle = { fg = "#a292a3" },
        colors = {
          theme = {
            all = {
              ui = { bg_gutter = "none" },
              syn = { parameter = "none" },
            }
          }
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          }
        end,
      })

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
      ]])

      vim.cmd([[
        set encoding=utf-8
        set ambiwidth=single

        set t_ut=                " fix 256 colors in tmux http://sunaku.github.io/vim-256color-bce.html

        if has("termguicolors")  " set true colors
          let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
          let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        endif
        set termguicolors
        colorscheme kanagawa-dragon
      ]])
    end
  }
}
