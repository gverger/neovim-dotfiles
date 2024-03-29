local M = {}

local utils = require('config.utils')

function M.setup()
  if not utils.has_plug('nvim-treesitter') then
    vim.notify('nvim-treesitter plugin not installed')
    return
  end

  local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
  parser_config.mosel = {
    install_info = {
      url = "~/git/tree-sitter-mosel/", -- local path or git repo
      files = { "src/parser.c" },           -- note that some parsers also require src/scanner.c or src/scanner.cc
      -- optional entries:
      branch = "main",                      -- default branch in case of git repo if different from master
    },
    filetype = "mos",                        -- if filetype does not match the parser name
  }

  -- Disabled because lagging on big files
  -- vim.cmd([[
  -- function! MyFoldText()
  --     let line = getline(v:foldstart)
  --     let line_chars = substitute(line, '[^a-zA-Z0-9]', '', 'g')
  --     if len(line_chars) == 0
  --       let line = line . trim(getline(v:foldstart+1))
  --     endif
  --     let folded_line_num = v:foldend - v:foldstart + 1
  --     " let fillcharcount = &textwidth - len(line_text) - len(folded_line_num)
  --     " return '+'. repeat('-', 4) . line_text . repeat('.', fillcharcount) . ' (' . folded_line_num . ' L)'
  --     return substitute(line,'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)).' ('.folded_line_num.'L)'
  -- endfunction
  --
  --
  -- set fillchars=fold:\
  -- augroup foldable
  --   autocmd!
  --   autocmd FileType * set foldmethod=expr foldexpr=nvim_treesitter#foldexpr() foldtext=MyFoldText() foldminlines=3 foldlevelstart=99 foldlevel=99
  -- augroup end
  -- ]])
end

return M
