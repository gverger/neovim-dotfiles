local M = {}

local utils = require('config.utils')

function M.setup()
  if not utils.has_plug('nvim-treesitter') then
    vim.notify('nvim-treesitter plugin not installed')
    return
  end

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
