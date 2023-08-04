local M = {}

local utils = require('config.utils')

function M.setup()
  if not utils.has_plug('nvim-treesitter') then
    vim.notify('nvim-treesitter plugin not installed')
    return
  end

  require 'nvim-treesitter.configs'.setup {
    indent = {
      enable = false,
    },
    highlight = {
      additional_vim_regex_highlighting = false,
      enable = true,
    },
    incremental_selection = {
      enable = true,
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
          ['@function.outer'] = 'V',
          ['@class.outer'] = 'V',
        },
      }
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
  }
  require'treesitter-context'.setup{
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    mode = 'topline',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  }
  vim.cmd([[
    autocmd ColorScheme * hi TreesitterContext guibg=#444444
  ]])
  -- vim.treesitter.language.register('c_sharp', 'csharp')

  vim.cmd([[
  function! MyFoldText()
      let line = getline(v:foldstart)
      let line_chars = substitute(line, '[^a-zA-Z0-9]', '', 'g')
      if len(line_chars) == 0
        let line = line . trim(getline(v:foldstart+1))
      endif
      let folded_line_num = v:foldend - v:foldstart + 1
      " let fillcharcount = &textwidth - len(line_text) - len(folded_line_num)
      " return '+'. repeat('-', 4) . line_text . repeat('.', fillcharcount) . ' (' . folded_line_num . ' L)'
      return substitute(line,'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)).' ('.folded_line_num.'L)'
  endfunction


  set fillchars=fold:\
  augroup foldable
    autocmd!
    autocmd FileType * set foldmethod=expr foldexpr=nvim_treesitter#foldexpr() foldtext=MyFoldText() foldminlines=3 foldlevelstart=99 foldlevel=99
  augroup end
  ]])
end

return M
